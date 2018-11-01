# utl-rearrange-the-elements-of-a-datastep-array-in-descending-order
Rearrange the elements of a datastep array in descending order.

    Rearrange the elements of a datastep array in descending order                                                    
                                                                                                                      
    gitnub                                                                                                            
    https://tinyurl.com/ybgsteqv                                                                                      
    https://github.com/rogerjdeangelis/utl-rearrange-the-elements-of-a-datastep-array-in-descending-order             
                                                                                                                      
      Two Solutions                                                                                                   
                                                                                                                      
           1. Faster using peek, poke and addr                                                                        
                Novinosrin profile                                                                                    
                https://communities.sas.com/t5/user/viewprofilepage/user-id/138205                                    
                                                                                                                      
           2. Slower method using a do loop                                                                           
                                                                                                                      
    SAS Forum                                                                                                         
    https://tinyurl.com/y8r9pdgp                                                                                      
    https://communities.sas.com/t5/New-SAS-User/How-to-create-new-variables-based-on-ranking-of-multiple/m-p/509331   
                                                                                                                      
                                                                                                                      
    INPUT                                                                                                             
    =====                                                                                                             
                                                                                                                      
    WORK.HAVE total obs=2                                                                                             
                                                                                                                      
     A    B    C                                                                                                      
                                                                                                                      
     1    2    3                                                                                                      
     5    1    4                                                                                                      
                                                                                                                      
                                                                                                                      
    EXAMPLE OUTPUT                                                                                                    
    ==============                                                                                                    
                                                                                                                      
     WORK.WANT total obs=2                                                                                            
                                                                                                                      
       A    B    C      TOP1    TOP2    TOP3                                                                          
                                                                                                                      
       1    2    3        3       2       1                                                                           
       5    1    4        5       4       1                                                                           
                                                                                                                      
    PROCESS                                                                                                           
    =======                                                                                                           
                                                                                                                      
     1. Faster using peek, poke and addr                                                                              
                                                                                                                      
        data want;                                                                                                    
                                                                                                                      
          set have;                                                                                                   
                                                                                                                      
          * original array;                                                                                           
          array s(*) a--c;                                                                                            
                                                                                                                      
          * in ascending order;                                                                                       
          array top(3) ;                                                                                              
                                                                                                                      
          * reverse the order of top  (make descending);                                                              
          array r[*] top3-top1;                                                                                       
                                                                                                                      
          * process;                                                                                                  
          * move original array into top;                                                                             
            call pokelong(put(peekclong(addrlong(s(1)),24),24.),addrlong(top[1]), 24);                                
            call sortn(of r[*]);                                                                                      
                                                                                                                      
        run;quit;                                                                                                     
                                                                                                                      
     2. Slower method using a do loop                                                                                 
                                                                                                                      
        data want;                                                                                                    
                                                                                                                      
          set have;                                                                                                   
                                                                                                                      
          * original array;                                                                                           
          array s(*) a--c;                                                                                            
                                                                                                                      
          * in ascending order;                                                                                       
          array top(3) ;                                                                                              
                                                                                                                      
          * reverse the order of top  (make descending);                                                              
          array r[*] top3-top1;                                                                                       
                                                                                                                      
          * process;                                                                                                  
          * move original array into top;                                                                             
            put a b c;                                                                                                
            do i=1 to 3;                                                                                              
              top[i]=s[i];                                                                                            
            end;                                                                                                      
            call sortn(of r[*]);                                                                                      
                                                                                                                      
        run;quit;                                                                                                     
                                                                                                                      
                                                                                                                      
