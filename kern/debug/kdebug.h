#ifndef __KERN_DEBUG_KDEBUG_H__
#define __KERN_DEBUG_KDEBUG_H__

#include <defs.h>
#include <trap.h>

#define _KERN_DEBUG_ 1

#ifdef _KERN_DEBUG_
#define KERN_DEBUG_FUN(x)																		\
do																								\
{																								\
	cprintf("%dst : function %s : line %u in %s file\n", x, __func__, __LINE__, __FILE__);		\
}while (0)

#else
#define KERN_DEBUG_FUN(x)
#endif

	

void print_kerninfo(void);
void print_stackframe(void);
void print_debuginfo(uintptr_t eip);


#endif /* !__KERN_DEBUG_KDEBUG_H__ */

