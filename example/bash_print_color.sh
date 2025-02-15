#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

color selector.
!

# \033[A;B;Cm
# \e[A;B;Cm
# A: 显示方式: 0(默认) 1(高亮) 4(下划线) 7(反显)
# B: 前景色(字体颜色)
# C: 背景色

printf "\e[2m (TEST: 2m) \e[0m\n";

printf "\033[2m (TEST: 2m) \033[0m\n";
printf "\033[4m (TEST: 4m) \033[0m\n";
printf "\033[7m (TEST: 7m) \033[0m\n";
printf "\033[9m (TEST: 9m) \033[0m\n";
printf "\033[30m (TEST: 30m) \033[0m\n";
printf "\033[31m (TEST: 31m) \033[0m\n";
printf "\033[32m (TEST: 32m) \033[0m\n";
printf "\033[33m (TEST: 33m) \033[0m\n";
printf "\033[34m (TEST: 34m) \033[0m\n";
printf "\033[35m (TEST: 35m) \033[0m\n";
printf "\033[36m (TEST: 36m) \033[0m\n";
printf "\033[37m (TEST: 37m) \033[0m\n";
printf "\033[41m (TEST: 41m) \033[0m\n";
printf "\033[42m (TEST: 42m) \033[0m\n";
printf "\033[43m (TEST: 43m) \033[0m\n";
printf "\033[44m (TEST: 44m) \033[0m\n";
printf "\033[45m (TEST: 45m) \033[0m\n";
printf "\033[46m (TEST: 46m) \033[0m\n";
printf "\033[47m (TEST: 47m) \033[0m\n";
printf "\033[90m (TEST: 90m) \033[0m\n";
printf "\033[91m (TEST: 91m) \033[0m\n";
printf "\033[92m (TEST: 92m) \033[0m\n";
printf "\033[93m (TEST: 93m) \033[0m\n";
printf "\033[94m (TEST: 94m) \033[0m\n";
printf "\033[95m (TEST: 95m) \033[0m\n";
printf "\033[96m (TEST: 96m) \033[0m\n";
printf "\033[100m (TEST: 100m) \033[0m\n";
printf "\033[101m (TEST: 101m) \033[0m\n";
printf "\033[102m (TEST: 102m) \033[0m\n";
printf "\033[103m (TEST: 103m) \033[0m\n";
printf "\033[104m (TEST: 104m) \033[0m\n";
printf "\033[105m (TEST: 105m) \033[0m\n";
printf "\033[106m (TEST: 106m) \033[0m\n";
printf "\033[107m (TEST: 107m) \033[0m\n";
