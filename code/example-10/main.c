/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ncarvalh <ncarvalh@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/06/01 21:43:38 by ncarvalh          #+#    #+#             */
/*   Updated: 2023/06/21 22:29:54 by ncarvalh         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

void hello(void);
void bye(void);
void highfive(void);
void hug(void);
void kiss(void);
void handshake(void);
void wave(void);

int main()
{
	hello();
	highfive();
	handshake();
	hug();
	kiss();
	wave();
	bye();
	return 0;
}