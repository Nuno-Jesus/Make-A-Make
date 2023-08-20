/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   nc_count.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: marvin <marvin@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/07/04 15:14:13 by ncarvalh          #+#    #+#             */
/*   Updated: 2023/08/20 12:54:26 by marvin           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int	nc_count(char *str, char c)
{
	int	counter;

	counter = 0;
	while (*str)
		if (*str++ == c)
			counter++;
	return (counter);
}
