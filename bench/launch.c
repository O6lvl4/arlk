/* Run one command in a fresh process and report how it went.
 *
 *   launch TIMEOUT_SECONDS LOGFILE CMD ARGS...
 *
 * prints one line:  STATUS WALL_SECONDS MAXRSS_KIB
 *
 *   STATUS       exit:N, signal:N, or timeout
 *   WALL         monotonic clock, from just before fork to the child's exit
 *   MAXRSS_KIB   ru_maxrss from wait4() on the child: the peak resident set
 *                of that one process (Linux reports KiB, macOS bytes; both
 *                are printed in KiB). It is the largest child's peak, not
 *                the sum over a process tree.
 *
 * The launcher is small and native, so the child starts from exec with no
 * inherited interpreter heap (a Python parent would put its own RSS under
 * the child's until exec). The child's output goes to LOGFILE.
 */
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static pid_t child = 0;
static volatile sig_atomic_t timed_out = 0;

static void on_alarm(int sig) {
  (void)sig;
  timed_out = 1;
  if (child > 0) kill(child, SIGKILL);
}

int main(int argc, char **argv) {
  if (argc < 4) {
    fprintf(stderr, "usage: launch TIMEOUT_SECONDS LOGFILE CMD ARGS...\n");
    return 2;
  }
  unsigned timeout = (unsigned)atoi(argv[1]);
  int log = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
  if (log < 0) { perror(argv[2]); return 2; }
  struct timespec t0, t1;
  clock_gettime(CLOCK_MONOTONIC, &t0);
  child = fork();
  if (child < 0) { perror("fork"); return 2; }
  if (child == 0) {
    dup2(log, 1);
    dup2(log, 2);
    close(log);
    execvp(argv[3], argv + 3);
    perror(argv[3]);
    _exit(127);
  }
  close(log);
  signal(SIGALRM, on_alarm);
  alarm(timeout);
  int status = 0;
  struct rusage ru;
  pid_t r;
  do { r = wait4(child, &status, 0, &ru); } while (r < 0 && errno == EINTR);
  clock_gettime(CLOCK_MONOTONIC, &t1);
  alarm(0);
  double wall = (double)(t1.tv_sec - t0.tv_sec) + (double)(t1.tv_nsec - t0.tv_nsec) / 1e9;
#ifdef __APPLE__
  long rss_kib = ru.ru_maxrss / 1024;
#else
  long rss_kib = ru.ru_maxrss;
#endif
  if (timed_out) printf("timeout %.6f %ld\n", wall, rss_kib);
  else if (WIFSIGNALED(status)) printf("signal:%d %.6f %ld\n", WTERMSIG(status), wall, rss_kib);
  else printf("exit:%d %.6f %ld\n", WEXITSTATUS(status), wall, rss_kib);
  return 0;
}
