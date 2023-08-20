/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: marvin <marvin@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/08/20 12:48:59 by marvin            #+#    #+#             */
/*   Updated: 2023/08/20 12:48:59 by marvin           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

size_t	nc_strlen(const char *s);

int	nc_strncmp(const char *s1, const char *s2, size_t n);

char	*nc_strnstr(const char *big, const char *little, size_t len);

char	*nc_substr(char const *s, unsigned int start, size_t len);

int	nc_clamp(int n, int min, int max);

int	nc_count(char *str, char c);

void	nc_free(void *ptr);

int	nc_numlen(int n);


int main(void)
{
	return (0);
}
