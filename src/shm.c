#include "include/shm.h"
#include <sys/mman.h>
#include <fcntl.h>
#include <time.h>
#include <errno.h>
#include <unistd.h>

static void randname(char *buffer) {
    struct timespec time;
    clock_gettime(CLOCK_REALTIME, &time);
    long r = time.tv_nsec;
    for (int i = 0; i < 6; ++i) {
        buffer[i] = 'A' + (r & 15) + (r & 16) * 2;
        r >>= 5;
    }
}

int allocate_shm_file(size_t size) {
    int fd = create_shm_file();
    if (fd < 0) {
        return -1;
    }
    int ret;
    do {
        ret = ftruncate(fd, size);
    } while (ret < 0 && errno == EINTR);
    
    if (ret < 0) {
        close(fd);
        return -1;
    }

    return fd;
}

int create_shm_file() {
    int retries = 100;
    do {
        char name[] = "shm-XXXXXX";
        randname(name + sizeof(name) - 7);
        --retries;
        int fd = shm_open(name, O_CREAT | O_RDWR, 0600);
        if (fd >= 0) {
            shm_unlink(name);
            return fd;
        }
    } while (retries > 0 && errno == EEXIST);
    return -1;
}
