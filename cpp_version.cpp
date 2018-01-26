#include <iostream>

using namespace std;

int abs_diff(int a, int b){
    if (a>=b) return (a-b);
    return b-a;
}

int min(int a,int b){
    if (a<b) return a;
    return b;
}

char print_char(int row,int index){
    int temp = min(row, index);
    return (65+temp);

}

int main(){
    
    cout<<"please enter the number of characters";
    int n;
    cin>>n;
    for(int i=0; i<((2*n)-1); i++){
        int row_index = -1*abs_diff(i, n-1) + n-1; // -|x-n|+n 
        for(int j=0; j<2*n-1; j++){
            int col_index = -1*abs_diff(j, n-1) + n-1; 
            cout<<print_char(row_index, col_index)<<'\t';
        }
        cout<<endl;
    }
    return 0;
}