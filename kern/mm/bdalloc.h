#ifndef _BDALLOC_H_
#define _BDALLOC_H_


#include <pmm.h>
#include <stdio.h>



extern const struct pmm_manager buddy_pmm_manager;

#define LEFT_LEAF(index) ((index) * 2 + 1)
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index) ( ((index) + 1) / 2 - 1)

#define IS_POWER_OF_2(x) (!((x)&((x)-1)))

#define MAX(a, b) ((a) > (b) ? (a) : (b))

#define buddy_nr_free (BuddyHead->longest[0])


struct buddy2
{
	unsigned size;
	unsigned longest[1];
};


#endif
