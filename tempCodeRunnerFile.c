#include <stdio.h>
#include <stdlib.h>

void main()
{

    int opcao, sair = 0, peso, num1;
    double altura, num2, num3;
    while (sair == 0)
    {
        printf("\n\nSELECIONE UMA DAS OPCOES ABAIXO:\n\n");
        printf("1 -\tInformacoes.\n");
        printf("2 -\tCalcular IMC (Indice de massa corporal)\n");
        printf("3 -\tVerificar se um numero é par ou impar\n");
        printf("4 -\tRealizar uma multiplicacao\n");
        printf("5 -\tRealizar uma divisao\n");
        printf("6 -\tSair\n\n");
        scanf("%d", &opcao);
        switch (opcao)
        {
            case 1:
                printf("1 -\tPrograma desenvolvido por Josiane de Sousa Alves - 15/0038895. Aluna do último semestre do curso " "de Engenharia Eletronica.\n\n");
            break;    
            case 2:
                printf("Insira o seu peso em kg: \n");
                scanf("%d",&peso);
                printf("Insira a sua altura em metros: \n");
                scanf("%lf",&altura);
                printf("\nO seu IMC e': %lf\n", peso / (altura*altura));

            break;
            case 3:
                printf("Insira um numero: \n");
                scanf("%d",&num1);
                if (num1 % 2 == 0)
                {
                    printf("\nO numero %d e' PAR.\n", num1);
                }
                else
                {
                    printf("\nO numero %d e' IMPAR.\n", num1);
                }
                
                
            break;
            case 4:
                printf("Insira um numero: \n");
                scanf("%lf",&num2);
                printf("Insira outro numero: \n");
                scanf("%lf",&num3);
                printf("\nO resultado da multiplicacao entre %lf e %lf e' %lf.\n", num2, num3, num2*num3);
                
            break;    
            case 5:
                num3 = 0;
                while(num3 == 0)
                {
                    printf("Insira o primeiro numero: \n");
                    scanf("%lf",&num2);
                    printf("Insira o segundo numero: \n");
                    scanf("%lf",&num3);
                    if (num3 == 0)
                    {
                        printf("\nO segundo numero deve ser diferente de zero!\n\n");
                    }
                    else
                    {
                        printf("\nO resultado da divisao entre %lf e %lf e' %lf.\n", num2, num3, num2 / num3);
                    }
                }
                
            break;
            case 6:
                sair = 1;
                printf("Muito obrigada! Ate a proxima.\n\n");
            break;
            default:
                printf("Insira uma opcao valida! (entre 1 e 6)\n");
            break;
        }
    }
}