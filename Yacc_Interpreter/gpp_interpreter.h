void printArr(int arr[],int lenn){
    int i;
    for(i=0;i< lenn;i++){
        if(i!= lenn -1)
            printf("%d ",arr[i]);
        else    
             printf("%d",arr[i]);    
    }
}

int* mAppend(int arr[],int lenn,int val){
    for (int i = lenn-1; i>=0; i--){
        arr[i+1]=arr[i];
    }
    arr[0]=val;
    return arr;
}