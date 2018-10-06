/*
 ============================================================================
 Name        : doctor.c
 Author      : wanghaidong
 Version     : 1.0
 Copyright   : Your copyright notice
 Description : 四川大学博士入学考试 高级程序设计
 ============================================================================
 */

#define product(x) (x*x)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/**
 * 2015
 */
void func_2015_1() {
	int i = 3, j, k;
	j = product(i++);
	k = product(++i);
	printf("j=%d, k=%d\n", j, k);
}


void func_2015_2() {
	int day, x1, x2;
	day = 0; x1 = 1020;
	while (x1 > 0) {
		x2 = x1/2 - 2;
		x1 = x2;
		day++;
	}
	printf("day=%d\n", day);
}


/**
 * 2013
 */
void func_2013_1() {
	int a = 1, b = 3, c = 5, d = 4;
	int x;
	if (a < b) {
		if (c < d) {
			x = 1;
		} else {
			if (a < c) {
				if (b < d) {
					x = 2;
				} else {
					x = 3;
				}
			} else {
				x = 6;
			}
		}
	} else {
		x = 7;
	}

	printf("x = %d\n", x);
}

void func_2013_2() {
	char s[20], str[3][20];
	int i;
	for (i = 0; i < 3; i++) {
		gets(str[i]);
	}
	strcpy(s, (strcmp(str[0], str[1]) < 0 ? str[0] : str[1]));
	if (strcmp(str[2], s) < 0) {
		strcpy(s, str[2]);
	}
	printf("%s\n", s);
}

void func_2013_3() {
	int a[][3] = { {1, 2, 3}, {4, 5, 0} }, (*pa)[3], i;
	pa = a;
	for (i = 0; i < 3; i++) {
		if (i <=2) {
			*(*(pa+1)+i) = *(*(pa+1)+i) - 1;
		} else {
			*(*(pa+1)+i) = 1;
		}
	}
	printf("%d\n", *(*(pa+1)+0) + *(*(pa+1)+1) + *(*(pa+1)+2));
}


/**
 * 2012
 */
int func_2012_1(int m) {
	int value;
	if (m == 0) {
		value = 3;
	} else {
		value = func_2012_1(m-1) + 5;
	}
	return (value);
}

void func_2012_1_2() {
	char a[] = "123456789", *p;
	int i = 0;
	p = a;
	while (*p) {
		if (i % 2 == 0) {
			*p = '*';
		}
		p++;
		i++;
	}
	puts(a);
}

void func_2012_1_3() {
	int s, t, a, b;
	scanf("%d, %d", &a, &b);
	s = 1; t = 1;
	if (a > 0) {
		s = s + 1;
	}
	if (a > b) {
		t = s + t;
	} else if (a == b) {
		t = 5;
	} else {
		t = 2 * s;
	}
	printf("s = %d, t = %d", s, t);
}

void func_2012_1_4() {
	char x = 3, y = 6, Z;
	Z = x^y<<2;	// Z = x^(y<<2);
	printf("%d\n", Z);
}


/**
 * 2011
 */
void func_2011_1_1() {
	int x;
	int a = 1, b = 3, c = 5, d = 4;
	if (a < b) {
		if (c < d) {
			x = 1;
		} else if (a < c) {
			if (b < d) {
				x = 2;
			} else {
				x = 3;
			}
		} else {
			x = 6;
		}
	} else {
		x = 7;
	}
	printf("x = %d\n", x);
}

void func_2011_1_2() {
	int a, b;
	for (a = 1, b = 1; a <= 100; a++) {
		if (b >= 20) {
			break;
		}
		if (b % 3 == 1) {
			b += 3;
			continue;
		}
		b -= 5;
	}
	printf("%d\n", a);
}

void func_2011_1_3() {
	int a[6][6], i, j;
	for (i = 1; i < 6; i++)
	{
		for (j = 1; j < 6; j++)
		{
			a[i][j] = (i / j) * (j / i);
		}
	}
	for (i = 1; i < 6; i++) {
		for (j = 1; j < 6; j++) {
			printf("%2d", a[i][j]);
		}
		printf("\n");
	}
}



/**
 * 2009
 */
void func_2009_1_1_1() {
	int a = 1, b = 2, c = 3;
	printf("%d\n", c>b>a);
	printf("\n");
}

void func_2009_1_2() {
	int *p, a = 10, b = 1;
	p = &a;
	a = *p + b;
	printf("%d\n", a);
}

void func_2009_1_3() {
//	char s[5] = "abcde";
//	char *s;
//	gets(s);
	char s[5];
	scanf("%s", &s);
	printf("%s\n", s);
}

void func_2009_1_4() {
	int k = 0;
	while (k = 1) {
		k++;
		printf("%d\n", k);
	}
}

void func_2009_2_1() {
	unsigned long num, max, t;
	int count;
	count = max = 0;
	scanf("%ld", &num);
	do {
		t = num % 10;
		if (t == 0) {
			++count;
		} else {
			if (max < t) {
				max = t;
			}
		}
		num /= 10;
	} while (num);
	printf("count=%d, max=%ld\n", count, max);
}

void exchange(int *x, int *y) {
	int t;
	t = *y;
	*y = *x;
	*x = t;
}
void func_2009_2_2() {
	int a = 3, b = 4;
	exchange(&a, &b);
	printf("%d, %d\n", a, b);
}

compare(char *s1, char *s2) {
	while (*s1 && *s2 && *s1 == *s2) {
		s1++;
		s2++;
	}
	return *s1 - *s2;
}
void func_2009_2_3() {
	printf("%d\n", compare("abCd", "abc"));
}

void func_2009_2_4() {
	char str[] = "wanghaidong";
	char m; int i, j;
	for (i = 0, j = strlen(str); i < strlen(str)/2; i++,j--) {
		m = str[i];
		str[i] = str[j-1];
		str[j-1] = m;
	}
	printf("%s\n", str);
}

struct stu {
	int num;
	char name[10];
	int age;
};

void func_2009_3_1(struct stu *p) {
	printf("%s\n", (*p).name);
}


void increment_2009_3_1(void);


void func_2009_3_3() {
	static char a[] = "ABCDEFGH", b[] = "abCDefGh";
	char *p1, *p2;
	int k;
	p1 = a; p2 = b;
	for (k = 0; k <= 7; k++) {
		if (*(p1+k) == *(p2+k)) {
			printf("%c", *(p1+k));
		}
	}
	printf("\n");
}

int func_2009_3_4(int x, int y, int *cp, int *dp) {
	*cp = x+y;
	*dp = x-y;
}


int main(void) {

	int a, b, c, d;
	a = 30; b = 50;
	func_2009_3_4(a, b, &c, &d);
	printf("%d,%d\n", c, d);

//	func_2009_3_3();

//	func_2015_1();
//	func_2015_2();
//
//	func_2013_1();
////	func_2013_2();
//	func_2013_3();
//
//	printf("%d\n", func_2012_1(3));
//	func_2012_1_2();
//	func_2012_1_3();
//	func_2012_1_4();
//
//	func_2011_1_1();
//	func_2011_1_2();
//	func_2011_1_3();
//	increment();
//	increment();
//	increment();
//	printf("\n");
//
//	func_2009_1_1_1();
//	func_2009_1_2();
//	func_2009_1_3();
//	func_2009_1_4();
//	func_2009_2_1();
//	func_2009_2_2();
//	func_2009_2_3();
//	func_2009_2_4();
//	struct stu students[3] = {
//			{9801, "Zhang", 20},
//			{9802, "Wang", 19},
//			{9803, "Zhao", 18}
//	};
//	func_2009_3_1(students+2);
//
//	increment_2009_3_1();
//	increment_2009_3_1();
//	increment_2009_3_1();

	return EXIT_SUCCESS;
}

void increment_2009_3_1(void) {
	static int x = 0;
	x++;
	printf("x = %d\n", x);
}


increment() {
	int x = 0;
	x += 1;
	printf("%d", x);
}






