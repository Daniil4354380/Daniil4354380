#include <ncurses.h>
#include <stdio.h>

#define N 25
#define M 80

void replace_matr(int matr2[N][M], int matr1[N][M]);
void new_matr(int matr1[N][M], int matr2[N][M]);
void input_matr(int matr1[N][M]);
int condition_origin(int cell, int near_cells);
int count_near_cells(int matr1[N][M], int x, int y);
int change_speed(char key, int speed, int *flag);
int count_live_cells(int matr1[N][M]);
int stat(int matr1[N][M], int matr2[N][M]);

int main() {
    int matr1[N][M];
    int matr2[N][M];
    int stop = 0;
    int speed = 500;
    curs_set(0);
    input_matr(matr1);
    if (freopen("/dev/tty", "r", stdin)) initscr();
    nodelay(stdscr, true);
    while (stop != 1) {
        char key = getch();
        if (count_live_cells(matr1) == 0) {
            stop = 1;
        }
        speed = change_speed(key, speed, &stop);
        timeout(speed);
        clear();
        new_matr(matr1, matr2);
        if (stat(matr1, matr2) == N * M) {
            stop = 1;
        }
        replace_matr(matr2, matr1);
    }
    endwin();
    return 0;
}

void input_matr(int matr1[N][M]) {
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < M; ++j) {
            scanf("%d", &matr1[i][j]);
        }
    }
}

void new_matr(int matr1[N][M], int matr2[N][M]) {
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < M; ++j) {
            matr2[i][j] = condition_origin(matr1[i][j], count_near_cells(matr1, i, j));
            if (matr2[i][j] == 1) {
                printw("*");
            } else {
                printw(" ");
            }
        }
        printw("\n");
    }
}

void replace_matr(int matr2[N][M], int matr1[N][M]) {
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < M; ++j) {
            matr1[i][j] = matr2[i][j];
        }
    }
}

int condition_origin(int cell, int near_cells) {
    int next;
    if (cell == 0 && near_cells == 3) {
        next = 1;
    } else if (cell == 1 && (near_cells == 2 || near_cells == 3)) {
        next = 1;
    } else {
        next = 0;
    }
    return next;
}

int count_near_cells(int matr1[N][M], int x, int y) {
    int count = 0;
    int x_min = x - 1, x_plus = x + 1, y_min = y - 1, y_plus = y + 1;
    if (x_min < 0) x_min = N - 1;
    if (y_min < 0) y_min = M - 1;
    if (x_plus > N - 1) x_plus = x_plus % N;
    if (y_plus > M - 1) y_plus = y_plus % M;

    count += matr1[x_min][y_min];
    count += matr1[x_min][y];
    count += matr1[x_min][y_plus];
    count += matr1[x][y_plus];
    count += matr1[x_plus][y_plus];
    count += matr1[x_plus][y];
    count += matr1[x_plus][y_min];
    count += matr1[x][y_min];

    return count;
}

int change_speed(char key, int speed, int *flag) {
    switch (key) {
        case 'q':
            *flag = 1;
            break;
        case '1':
            speed = 50;
            break;
        case '2':
            speed = 300;
            break;
        case '3':
            speed = 800;
            break;
        default:
            break;
    }
    return speed;
}

int count_live_cells(int matr1[N][M]) {
    int sum = 0;
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < M; ++j) {
            sum += matr1[i][j];
        }
    }
    return sum;
}

int stat(int matr1[N][M], int matr2[N][M]) {
    int count = 0;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {
            if (matr1[i][j] == matr2[i][j]) count++;
        }
    }
    return count;
}
