#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "car.h"
#define START_ID 1000
void one();
void two();
void three();
void four();
void five();
void six();
int id;
FILE *fp;
int i;
char c;
int sum;
struct car rec;
struct car rec2;
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
		printf("1. register\n");
		printf("2. query\n");
		printf("3. update\n");
		printf("4. delete\n");
		printf("5. print all data\n");
		printf("6. Quit\n");
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
		printf("%4s %4s %4s %4s %4s %4s\n", "관리번호","번호판","제조사","연식","주행거리","가격");
		scanf("%d %s %s %d %d %d", &rec2.id, rec2.number, rec2.maker, &rec2.year, &rec2.mileage, &rec2.price);

		if( (rec2.id > 99999) || (rec2.id < 10000) )
		{
			printf("관리번호를 5자리로 맞춰주세요.\n");
			return one();
		}
		fseek(fp, (rec2.id-START_ID) *sizeof(rec2), SEEK_SET);
		if((fread(&rec, sizeof(rec), 1, fp) > 0)&&(rec.id >= 1))
		{
			
			printf("관리번호가 있습니다.\n");
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
		printf(" 관리번호 입력하세요 ");
		if(scanf("%d",&id)==1)
		{
			fseek(fp,(id-START_ID) *sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0) && (rec.id >=1))
				printf("관리번호:%8d 번호판: %4s 제조사:%4s 연식: %4d 주행거리 : %4d 가격 : %4d\n", rec.id, rec.number, rec.maker, rec.year, rec.mileage, rec.price);
			else printf("레코드 %d 없음 \n",id);
			}
			else printf("입력 오류");

		printf("계속하시겠습니까? (Y/N)");
		scanf(" %c",&c);
	}while (c == 'Y');
	
	
	
}

void three(){
	do{
		printf("수정할 관리번호를 입력: ");
		if(scanf("%d", &id) == 1){
			fseek(fp,(id-START_ID) *sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0)&&(rec.id >= 1)) {
				printf("관리번호: %8d 번호판: %4s 제조사: %4s 연식 : %4d 주행거리 : %4d 가격 : %4d\n ", rec.id, rec.number, rec.maker, rec.year, rec.mileage, rec.price);
				printf("바꾸고싶은 옵션을 선택 \n a. number : b. mileage c.price \n ");
				scanf(" %c",&c);
				if(c == 'a')	
				{
					printf("바꾸실내용을 입력\n");
					scanf("%s", rec.number);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec, sizeof(rec), 1, fp);
		printf("관리번호: %8d 번호판: %4s 제조사: %4s 연식 : %4d 주행거리 : %4d 가격 : %4d\n ", rec.id, rec.number, rec.maker, rec.year, rec.mileage, rec.price);
				}
				else if (c == 'b')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%d", &rec.mileage);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
		printf("관리번호: %8d 번호판: %4s 제조사: %4s 연식 : %4d 주행거리 : %4d 가격 : %4d\n ", rec.id, rec.number, rec.maker, rec.year, rec.mileage, rec.price);
				}
				else if (c == 'c')
				{
					printf("바꾸실내용을 입력\n");
					scanf("%d", &rec.price);
					fseek(fp, -sizeof(rec), SEEK_CUR);
					fwrite(&rec,sizeof(rec), 1, fp);
		printf("관리번호: %8d 번호판: %4s 제조사: %4s 연식 : %4d 주행거리 : %4d 가격 : %4d\n ", rec.id, rec.number, rec.maker, rec.year, rec.mileage, rec.price);
				}

			} 
		} else printf("입력오류\n");
		
		printf("관리번호가없거나 수정을 마쳤습니다\n");
		printf("새로운 관리번호를 입력하시겠습니까(Y/N)\n");

		scanf(" %c",&c);
	}while (c == 'Y');
	

	

}

void four(){
	do{
		printf("삭제할 관리번호를 입력: ");
		if(scanf("%d", &id) == 1){
			fseek(fp,(id-START_ID) * sizeof(rec), SEEK_SET);
			if((fread(&rec, sizeof(rec), 1, fp) > 0)&&(rec.id != 0)){
				printf("관리번호: %8d 번호판: %4s 제조사: %4s 연식 : %4d 주행거리 : %4d 가격 : %4d\n ", rec.id, rec.number, rec.maker, rec.year, rec.mileage, rec.price);
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
	int sum=0;
	int carcount=0;
	printf("%4s %4s %4s %4s %4s %4s\n", "관리번호","번호판","제조사","연식","주행거리","가격");
	
	
		for(int i=1;i<100000;i++)
		{
		fseek(fp,(9000+i) *sizeof(rec)  , SEEK_SET);
		if((fread(&rec, sizeof(rec), 1, fp) > 0) && (rec.id >= 1 ))	
		{
			printf("%4d %4s %4s %4d %4d %4d\n", rec.id, rec.number, rec.maker, rec.year, rec.mileage, rec.price);
		
			sum += rec.price;
		
			carcount++;
		}

		}
		
		printf("현재 자동차 개수:%d\n",carcount);
		if(carcount !=0)
		printf("가격 평균 :%d\n",sum/carcount);

}
void six(){
	exit(0);
} 
