#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "man.h"
#define START_ID 20000000
void one();
void two();
void three();
void four();
void five();
void six();
char trash[20];
int id;
char name[20];
char email[30];
int tel;
FILE *fp;
int i;
char c;
int sum;
char major[20];
void ppp();
struct man rec;
struct man rec2;
int main(int argc, char *argv[])  
{ 
	int input;

	if (argc != 2) {
		fprintf(stderr, "사용법: %s 파일이름\n",argv[0]);
		exit(1); 
	}

	if ((fp = fopen(argv[1], "rb+")) == NULL) {
		if ((fp = fopen(argv[1], "wb+")) == NULL) {
      		fprintf(stderr, "파일 열기 오류\n");
      		exit(1);
		}
   }

	while(1) {
		printf("1. 학생등록\n");
		printf("2. 검색\n");
		printf("3. 수정\n");
		printf("4. 삭제\n");
		printf("5. 학과별 출력\n");
		printf("6. 나가기\n");
		printf("Enter: ");

		scanf("%d", &input);

		switch(input) {
			case 1:
				
				one();

				break;
			       
			case 2: 
				
				two();
				

				break;
			case 3: 
				three();

				break;
			case 4:
			       four();	
				break;
			case 5: 
				five();
				break;
			case 6: 
				six();
				return 0;
		
			default: 
				break;
		}
	}


	fclose(fp);
	return 0;
} 

void one()
{	
	do
	{
		
		printf("소속학과는 컴퓨터공학과, 기계공학과, 건축공학과 중 하나를 정해서 입력해주세요\n\n ");
		printf("%4s %4s %4s %4s %4s %4s %4s %4s %4s %4s %4s\n", "학번","이름","전화번호","이메일","주소","소속학과","학년","장학금총액", "다전공내용","졸업여부(0,1)","휴학여부(0,1)");
		scanf("%d %s %d %s %s %s %d %d %s %d %d", &rec2.id, rec2.name, &rec2.tel, rec2.email, rec2.address, rec2.major, &rec2.grade, &rec2.money, rec2.minor, &rec2.leave, &rec2.graduate);
		fseek(fp, (rec2.id-START_ID) *sizeof(rec2), SEEK_SET);
		if((fread(&rec, sizeof(rec), 1, fp) > 0)&&(rec.id >= 1))
		{
			
			printf("학번이 있습니다.\n");
			return one();
		}
		else 
		{
			if( rec.id == -1) 
			fseek(fp, -sizeof(rec), SEEK_CUR);
			
			fwrite(&rec2, sizeof(rec), 1, fp);
		}
		
			
		
		printf("계속하시겠습니까? (Y/N)");
		scanf(" %c",&c);}
	while( c == 'Y');
		
	 
		
}
		
void two()
{

	do{
		printf("검색할 메뉴를 선택해주세요\n ");
		printf("a.학번 b.이름 c. 전화번호  d.이메일 e. 졸업확인 f. 휴학확인 \n"); 
		scanf(" %c", &c);
	if(c == 'a')	
	{
		printf("학번을 입력하세요\n");
		if(scanf("%d",&id)==1)
		{
			fseek(fp,(id-START_ID) *sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0) && (rec.id >=1))
			ppp();

		
			else printf("레코드 %d 없음 \n",id);
			}}
	
	else if(c == 'b')	
	{
		if(scanf("%s",name)==1)
		{
		for(int i=0;i<300000;i++)
		{
		fseek(fp, i*sizeof(rec) , SEEK_SET);
	
		
		if((fread(&rec, sizeof(rec), 1, fp) > 0) && (!strcmp(rec.name,name)))
		{
			if(rec.id >= 1)
				ppp();
		}
		}
			}else printf("레코드 %s 없음 \n",name);
			}
			
	else if(c == 'c')	
	{
		if(scanf("%d",&tel)==1)
		{
		for(int i=0;i<300000;i++)
		{
		fseek(fp,i *sizeof(rec)  , SEEK_SET);
		if((fread(&rec, sizeof(rec), 1, fp) > 0) && (rec.tel == tel))
		{
			if(rec.id >= 1)
			ppp();
		}
		}
			}else printf("레코드 %d 없음 \n",tel);
			}
	else if(c == 'd')	
	{
		if(scanf("%s",email)==1)
		{
		for(int i=0;i<300000;i++)
		{
		fseek(fp,i *sizeof(rec)  , SEEK_SET);
		if((fread(&rec, sizeof(rec), 1, fp) > 0) && (!strcmp(rec.email,email)))
		{
			if(rec.id >= 1)
				ppp();}
		}
			}else printf("레코드 %s 없음 \n",email);
			}
	if(c == 'e')	
	{
		printf("학번을 입력하세요\n");
		if(scanf("%d",&id)==1)
		{
			fseek(fp,(id-START_ID) *sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0) && (rec.id >=1))
			{
				if(rec.leave == 1)
				printf("졸업한 학생입니다.\n");
				else
					printf("졸업한 학생이 아닙니다.\n");
				
			}
		
			else printf("레코드 %d 없음 \n",id);
			}}
	if(c == 'f')	
	{
		printf("학번을 입력하세요\n");
		if(scanf("%d",&id)==1)
		{
			fseek(fp,(id-START_ID) *sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0) && (rec.id >=1))
			{
				if(rec.graduate == 1)
					printf("휴학중 입니다.\n");
				else
					printf("휴학중이 아닙니다.\n");
			}
				

		
			else printf("레코드 %d 없음 \n",id);
			}}
	
		printf("계속하시겠습니까? (Y/N)");
		scanf(" %c",&c);
	}while (c == 'Y');
	
	
	
}

void three(){
	do{
		printf("수정할 학번을 입력: ");
		if(scanf("%d", &id) == 1){
			fseek(fp,(id-START_ID) *sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0)&&(rec.id >= 1)) {
				ppp();
				printf("바꾸고싶은 옵션을 선택 \n a. 전화번호 : b. 이메일  c.주소  d.소속학과  e. 학년 f.장학금  g. 다전공 내용 h.졸업 수정 j.휴학 수정\n ");
				scanf(" %c",&c);
				if(c == 'a')	
				{
					printf("바꾸실내용을 입력\n");
					scanf("%d", &rec.tel);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec, sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'b')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%s", rec.email);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'c')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%s", rec.address);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'd')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%s", rec.major);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'e')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%d", &rec.grade);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'f')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%d", &rec.money);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'g')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%s", rec.minor);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'h')
				{
					printf("졸업이면 '1'을 재학이면 '0'을 입력해주세요\n");
					scanf("%d", &rec.leave);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}
				else if (c == 'j')
				{
					printf("휴학이면 '1'을 재학이면 '0'을 입력해주세요\n");
					scanf("%d", &rec.graduate);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
				ppp();
				}

			} 
		} else printf("입력오류\n");
		
		printf("학번이 없거나 수정을 마쳤습니다\n");
		printf("다른 학번을 입력하시겠습니까(Y/N)\n");

		scanf(" %c",&c);
	}while (c == 'Y');
	

	

}

void four(){
	do{
		printf("삭제할 학번을 입력: ");
		if(scanf("%d", &id) == 1){
			fseek(fp,(id-START_ID) * sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0)&&(rec.id != 0)){
				ppp();

				rec.id = -1;
				
				
				fseek(fp,-sizeof(rec), SEEK_CUR);
				fwrite(&rec,sizeof(rec), 1, fp);
				
				
				
				} else printf("해당 %d 관리번호 없음\n", id);
		} else printf("입력오류\n");

		printf("계속하겠습니다?(Y/N)");
		scanf(" %c",&c);
	}while (c == 'Y');


}

void five(){			
		printf("출력하고싶은 학과를 입력해주세요\n");
		printf("정확히 입력해주세요 예)컴퓨터공학과\n"); 
		if(scanf("%s",major)==1)
		{
		for(int i=0;i<300000;i++)
		{
		fseek(fp, i*sizeof(rec) , SEEK_SET);

		if((fread(&rec, sizeof(rec), 1, fp) > 0) && (!strcmp(rec.major,major))){
			if(rec.id >= 1)
				ppp();
			
		}
		}
		
			}
		
			
		
	

}
void six(){
	exit(0);
} 
void ppp(){
	printf("학번:%8d 이름: %4s 전화번호:%4d 이메일: %4s 주소 : %4s 소속학과 : %4s 학년 : %4d 장학금 총액: %4d 다전공 내용 : %4s 졸업여부: %4d 휴학여부: %4d \n", rec.id, rec.name, rec.tel, rec.email, rec.address, rec.major, rec.grade, rec.money, rec.minor, rec.leave, rec.graduate);
}

