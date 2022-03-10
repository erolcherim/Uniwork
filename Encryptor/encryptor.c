//CHERIM EROL grupa 241
//PROIECT SO - tema 20
//apel tip ./encode nume_fisier_intrare mod nume_fisier_iesire(mod: -e pentru encrypt -d pentru decrypt)
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <string.h>


void chVal(char *a, char *b){ //schimbare valori
	char temp = *a;
	*a = *b;
	*b = temp;
}

char *my_itoa(int num, char *str) //int to string explicit, nu merge default in compilator
{
        if(str == NULL)
        {
                return NULL;
        }
        sprintf(str, "%d", num);
        return str;
}

char* encrypt(char* cuv){ //functie de criptare
	int r;
	int l = strlen(cuv);
	char* perms = (char *)calloc(2500, sizeof(char));
	for (int j=0; j<l; j++){
		r = rand()%(l-j);
		chVal(&cuv[j], &cuv[r]);
		//strcat(perms, "(");
		char nr1[10];
		my_itoa(j, nr1);
		strcat(perms, nr1);
		strcat(perms, ">");
		char nr2[10];
		my_itoa(r, nr2);
		strcat(perms, nr2);
		strcat(perms, ">");
		//strcat(perms, ",");
	}
	return perms;
}

char* decrypt(char word[], char key[]){ //functie de decriptare
	int nspkp = 0;
	char ** v_keyp = NULL;
	
	char *keyp = strtok(key,">");
	
	while (keyp !=NULL){
		v_keyp = realloc (v_keyp, sizeof(char*)* ++nspkp);
		v_keyp[nspkp-1] = keyp;
		keyp = strtok(NULL, ">"); 
	}
	
	int l = strlen(word);
	for (int i=0; i<nspkp; i++){
		//printf("%d ", atoi(v_keyp[i]));
	}
	//l = 6
	//0 3 1 1 2 1 3 1 4 1 5 0
	//0 1 2 3 4 5 6 7 8 9 10 11
	//chVal(&word[5],&word[0]); 11 10
	//chVal(&word[4],&word[1]); 9 8
	//chVal(&word[3],&word[1]); 7 6
	//chVal(&word[2],&word[1]); 5 4
	//chVal(&word[1],&word[1]); 3 2 
	//chVal(&word[0],&word[3]); 1 0
	for (int i=2*l-1; i>0; i=i-2){
		chVal(&word[atoi(v_keyp[i])],&word[atoi(v_keyp[i-1])]);
	}
	return word;
	
	
}


int main(int argc, char *argv[]){

	int szi;
	char ** v_cuv = NULL;
	
	int nspw =0;
	int nspk =0;
	char ** v_w = NULL;
	char ** v_k = NULL;
	int nsp = 0;
	int i;
	
	srand(12345);
	
	int fi = open(argv[1], O_RDONLY, O_CREAT); //citire din fisier cu file descriptor
	char *c = (char *) calloc(25000, sizeof(char));
	
	szi = read(fi, c, 1000);
	if (strcmp(argv[2],"-e")==0){ 
		printf("encrypting...\n");
		char *p = strtok(c, " ");
		//generam un array unidimensional cu fiecare cuvant din string
		while (p != NULL){
			v_cuv = realloc (v_cuv, sizeof(char*) * ++nsp);
			
			if (v_cuv == NULL)
				exit(-1); //alloc failed
			
			v_cuv[nsp-1]=p;			
			p = strtok(NULL, " ");
		}
		printf("encrypted file %s, with output:\n", argv[1]);
	}
	
	else if (strcmp(argv[2],"-d")==0){
		char *p = strtok(c, " ");
		while (p != NULL){
			v_cuv = realloc (v_cuv, sizeof(char*) * ++nsp);
			
			if (v_cuv == NULL)
				exit(-1); //alloc failed
			
			v_cuv[nsp-1]=p;			
			p = strtok(NULL, " ");
		}
		for (int i; i<nsp; i++){
			if (i%2==1){
				v_w = realloc(v_w, sizeof(char*) * ++nspw);
				v_w[nspw-1] = v_cuv[i];
			}
			if (i%2==0){
				v_k = realloc(v_k, sizeof(char*) * ++nspk);
				v_k[nspk-1] = v_cuv[i];
			}
		}
		printf("decrypted file %s, with output:\n", argv[1]);

	}
	
	printf("\n-----------------------------------------------------\n");
	
	//se creaza obiectul de memorie partajata (in parinte)
	const char *shm_name = "/shared_file";
   	/*
    	se deschide obiectul de memorie partajata (ownerul are drepturi de citire/scriere)
   	 prin O_CREAT, se creaza obiectul de memorie partajata daca acesta nu exista
   	 S_IRUSR / S_IWUSR se pot inlocui cu 0400
	*/	
	int shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
	//abordarea aloca o pagina de memorie fiecarui proces https://man7.org/linux/man-pages/man2/getpagesize.2.html
	//dimensiunea unei pagini de memorie se poate obtine cu getpagesize() si de obicei (cel putin pt amd64 i386) este 4096b (4kb)
	size_t shm_page_size = 4096;
	//dimensiunea obiectului de memorie partajat va fi numarul de copii*dimenisunea unei pagini (in acest caz, cate un copil pentru fiecare cuvant din fisier)
	size_t shm_size = nsp*shm_page_size;
	
	if(shm_fd<0){
		printf("Cannot create shared memory object");
	}
	
	ftruncate(shm_fd, shm_size);
	//eroare la ftruncate (0 successful/ -1 unsuccessful https://www.ibm.com/docs/en/i/7.3?topic=ssw_ibm_i_73/apis/ftruncat.htm)
	if(ftruncate(shm_fd, shm_size)==-1){
		printf("Cannot truncate shared memory file");
		shm_unlink(shm_name); //dealocam memorie (eliberare resurse folosite)
    	}  

    	char* shm_mem;	
    	int k=0;
    	
    	for (k=0; k<nsp-1; k++){
    		shm_mem = mmap(NULL, shm_page_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, (k)*shm_page_size);
    		pid_t pid = fork();
    		
    		if (pid<0){
    			printf("Error creating child");
    		}
    		
    		if (pid==0){
    			if (strcmp(argv[2],"-e")==0){
				shm_mem += sprintf(shm_mem, "%s ", encrypt(v_cuv[k]));
				shm_mem += sprintf(shm_mem, "%s \n", v_cuv[k]);
			}
			else if (strcmp(argv[2],"-d")==0){
				shm_mem += sprintf(shm_mem, "%s \n", decrypt(v_w[k], v_k[k]));
			}
			//printf("Done parent %d Me %d\n", getppid(), getpid());
		exit(0);
    		}
    		
    		munmap(shm_mem, shm_page_size);
    		wait(NULL);

	}
	
	int szo;
	int fo = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	
        for(k=0; k<nsp-1; k++){
            shm_mem=mmap(NULL, shm_page_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, (k)*shm_page_size);
            printf("%s", shm_mem);
            szo = write(fo, shm_mem, strlen(shm_mem));
            munmap(shm_mem, shm_page_size); //eliberare resurse folosite
        }
	
        shm_unlink(shm_name); //eliberare resurse folosite
        //printf("Done parent %d ME %d\n", getppid(), getpid());
        
	
	return 0;
	
}

