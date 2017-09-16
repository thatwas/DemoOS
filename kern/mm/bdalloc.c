#include <bdalloc.h>
#include <pmm.h>
#include <list.h>
#include <string.h>

/*
 *���˼�룺ǰ��̽������ж��ٸ�ҳ�档������ʹ�õ�pageҳ�����ض�Ϊ2����������
 *
 *
 *
 */
 static struct buddy2* BuddyHead = NULL;
 static struct Page* BuddyPageHead = NULL;
 static size_t BuddyNum = 0;

 static unsigned fixsize(unsigned size) {
	size |= size >> 1;
	size |= size >> 2;
	size |= size >> 4;
	size |= size >> 8;
	size |= size >> 16;
	return size + 1;
}

 static void
 buddy_init(void)
 {
 	/*now there is nothing to do*/
 	cprintf("now there is nothing to do\n");
 }

/*
 *��n����ȡ2����������
 *
 */
 static size_t nm2truc(size_t nm)
 {
 	size_t x = 1;
 	while (x < nm)
		x <<= 1;

	return x/2;
 }
 
 static void
 buddy_init_memmap(struct Page *base, size_t n)
 {
 	unsigned node_size = 0;
	unsigned i = 0;
	
 	if (!IS_POWER_OF_2(n))
		n = nm2truc(n);

	BuddyNum = n;

	//uintptr_t base_int = page2kva(base);

	//����Ҫ���� 2 * 16384 * 4���ֽڵĴ�ŵ�ַ��һ����32ҳ�������ŵ��������ַ
	uintptr_t new_freemem = (uintptr_t)(page2kva(base) + sizeof(unsigned) * 2 * n);



	//���Ǹ������ַ,ҳ��ת�������ַ�������Head����ʵ��ַ
	BuddyHead = page2kva(base);
	
	BuddyHead->size = n;
	
	new_freemem = ROUNDUP(new_freemem, PGSIZE);
	

	//���page���鵱�е�׼ȷ���
	BuddyPageHead = (struct Page*)pa2page(PADDR(new_freemem));

		
	node_size = n * 2;

	for (i = 0; i < 2 * n - 1; ++i)
	{
		if (IS_POWER_OF_2(i+1))
			node_size /= 2;
		BuddyHead->longest[i] = node_size;
	}
	
//done!!	
		
 }

 static struct Page*
 buddy_alloc_pages(size_t n)
 {
 	assert(n > 0);
	
 	//��Ҫ���б�־λ�趨
	unsigned offset = 0;
	unsigned index = 0;
	int i = 0;
	unsigned node_size = BuddyHead->size;
	unsigned size = BuddyHead->size;
	struct Page* res;

	if (!IS_POWER_OF_2(n))
		n = fixsize(n);

	if (BuddyHead->longest[index] < n)
			return NULL;

	//ִ�е��⣬˵��һ���ֿ��Է���ĵط�����������
	for (;node_size != n; node_size /= 2)
	{
		if (BuddyHead->longest[LEFT_LEAF(index)] >= n)
			index = LEFT_LEAF(index);
		else
			index = RIGHT_LEAF(index);
	
	}
	
	offset = (index + 1) * node_size - size;
	
	BuddyHead->longest[index] = 0;

	
	res = BuddyPageHead + offset;

	
	//�Ը��ڵ���д���
	while (index)
	{
		index = PARENT(index);
	
		BuddyHead->longest[index] = 
			MAX(BuddyHead->longest[LEFT_LEAF(index)], BuddyHead->longest[RIGHT_LEAF(index)]);
	}

	
	for (i = 0; i < n; i++)
	{
		SetPageReserved(res + i);
		//����ҳ�������Ϊ0����Ϊ����û�����õ�
		set_page_ref(res + i, 0);
	}
			
	return res;
 }
 
 static void
 buddy_free_pages(struct Page *base, size_t n)
 {
 	assert(n > 0);
	
 	//��������n��û���õ�
 	unsigned offset = 0;
	unsigned index = 0;
	unsigned node_size = 1;
	unsigned left = 0;
	unsigned right = 0;
	
	struct Page* p = base;

	
	if (!IS_POWER_OF_2(n))
		n = fixsize(n);
	
	offset = base - BuddyPageHead;
	
	index = offset + BuddyHead->size - 1;
	
	for (; p != base + n; ++p) 
	{		
		assert(PageReserved(p));
		set_page_ref(p, 0);
	}

	
	while (index)
	{
		if (BuddyHead->longest[index] == 0)
			break;
		index = PARENT(index);
		node_size *= 2;
	}
	
	BuddyHead->longest[index] = node_size;
	
	//�����������
	while (index)
	{
		index = PARENT(index);
		node_size *= 2;
	
		left = BuddyHead->longest[LEFT_LEAF(index)];
		right = BuddyHead->longest[RIGHT_LEAF(index)];
	
		if (node_size == (left + right))
		{
			BuddyHead->longest[index] = node_size;
		}
		else
		{
			BuddyHead->longest[index] = MAX(BuddyHead->longest[LEFT_LEAF(index)], BuddyHead->longest[RIGHT_LEAF(index)]);
		}
	}
	
 }

 static size_t
 buddy_nr_free_pages(void) 
 { 
 	return buddy_nr_free;
 }

 /*��μ��buddy���ڴ����ϵͳ�Ƿ���ȷ:
  *
  *16384������ҳ
  */

 static void
 basic_buddy_check(void)
 {
 	struct Page* p0, *p1, *p2;

	assert((p0 = alloc_page()) == BuddyPageHead);
	assert((p1 = alloc_page()) == (BuddyPageHead + 1));
	assert((p2 = alloc_page()) == (BuddyPageHead + 2));

	
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

	free_page(p0);
    free_page(p1);
    free_page(p2);

	//��������ҳ��һ��

	assert((p0 = alloc_pages(BuddyNum/2)) == BuddyPageHead);
	assert((p1 = alloc_pages(BuddyNum/2)) == (BuddyPageHead + BuddyNum/2));

	assert((p2 = alloc_page()) == NULL);

	free_page(p0);
    free_page(p1);

	//
	assert((p0 = alloc_page()) == BuddyPageHead);
	assert((p1 = alloc_pages(BuddyNum)) == NULL);
	assert((p2 = alloc_pages(BuddyNum/2)) == (BuddyPageHead + BuddyNum/2));

	free_page(p0);
    free_page(p2);
	
	
 }
 static void 
 buddy_check(void)
 {
 	basic_buddy_check();

	cprintf("max free page is %u\n", nr_free_pages());
 }
 
 const struct pmm_manager buddy_pmm_manager = {
	  .name = "buddy_pmm_manager",
	  .init = buddy_init,
	  .init_memmap = buddy_init_memmap,
	  .alloc_pages = buddy_alloc_pages,
	  .free_pages = buddy_free_pages,
	  .nr_free_pages = buddy_nr_free_pages,
	  .check = buddy_check,
  };

