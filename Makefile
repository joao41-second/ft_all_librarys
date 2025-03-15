# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rui <rui@student.42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/05/03 06:17:31 by jperpect          #+#    #+#              #
#    Updated: 2025/03/14 22:48:59 by jperpct          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Compiler flags
#WFLGS = -Wall -Wextra -Werror
#READ_FLG = -g 

Libft_dir = ./libft/ft_libft
libft = $(Libft_dir)/libft


FLGS_LIB = $(Libft_dir)/libft.a ./libft/ft_free/ft_free.a ./libft/ft_list/lsit.a ./libft/ft_printf/libftprintf.a
FLGS = $(WFLGS) $(READ_FLG) 

DIRS := ft_get_next_line ft_printf ft_list ft_free ft_libft

VAL = valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --track-origins=yes --trace-children=yes --suppressions=readline.supp 

# Make flags
MAKEFLAGS += -s

# Source files
SRCS = $(shell find src -name '*.c')

# Object files
OBJS = $(patsubst src/%.c,$(OBJDIR)/%.o,$(SRCS))

# Libraries
LIB = ./libft/libft/libft.a 

# Commands
AR = ar rcs
CC = cc
RM = rm -f
CAT = cat number.txt

# Output
NAME = minishell
OBJDIR = Objs

# Create object directory if it doesn't exist
$(shell mkdir -p $(OBJDIR))

$(OBJDIR)/%.o: src/%.c
	@mkdir -p $(dir $@)
	@$(CC) -c $(FLGS) -o $@ $<
# Compile all source files
$(OBJDIR)/%.o: src/%.c
	@mkdir -p $(dir $@)
	@$(CC) -c $(FLGS) -o $@ $<

# Phony targets
.PHONY: all clean fclean re exec norm normi

all: check_repos $(NAME)

check_repos:
	@for dir in $(DIRS); do \
		path="libft/$$dir"; \
		if [ ! -d "$$path" ]; then \
			echo "Clonando repositório $$dir"; \
			mkdir -p libft; \
			cd libft && git clone git@github.com:joao41-second/$$dir.git; \
			cd .. ;\
		elif [ -z "$(ls -A $$path 2>/dev/null)" ]; then \
			echo "Clonando repositório $$dir"; \
			rm  $$path ;\
			cd libft && git clone git@github.com:joao41-second/$$dir.git; \
			cd .. ;\
		fi; \
	done

$(NAME): $(OBJS) 
	cd libft/ft_free && make 
	cd libft/ft_libft && make bonus
	cd libft/ft_list && make 
	cd libft/ft_printf && make
	cd libft/ft_get_next_line && make
	$(CC) $(OBJS)  $(FLGS_LIB) $(FLGS) -o $(NAME)
	@echo "╔══════════════════════════╗"
	@echo "║ ✅ Compiled Successfully!║"
	@echo "╚══════════════════════════╝"




clean:
	$(RM) -r $(OBJDIR)
	cd ./libft/ft_libft/ && make clean
	cd ./libft/ft_free/  && make clean
	cd ./libft/ft_list/  && make clean
	cd ./libft/ft_printf/  && make clean
	cd ./libft/ft_get_next_line/ && make clean

fclean: clean
	$(RM)  $(NAME)

re: fclean all

exec:
	$(CC) -g $(FLGS) $(SRCS)

norm:
	yes y| python3 -m c_formatter_42 -c $(SRCS)

normi:
	norminette $(SRCS)
	cd ./libft && norminette

s:
	clear && make re 

