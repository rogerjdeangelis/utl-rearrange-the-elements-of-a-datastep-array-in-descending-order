Rearrange the elements of a datastep array in descending order                                                      
                                                                                                                    
gitnub                                                                                                              
https://tinyurl.com/ybgsteqv                                                                                        
https://github.com/rogerjdeangelis/utl-rearrange-the-elements-of-a-datastep-array-in-descending-order               
                                                                                                                    
  Two Solutions                                                                                                     
                                                                                                                    
       1. Faster using peek, poke and addr                                                                          
            Novinosrin profile                                                                                      
            https://communities.sas.com/t5/user/viewprofilepage/user-id/138205                                      
                                                                                                                    
       2. Slower method using a do loop   
       
  Additiona preferred solution?
  See simple, elegant and flexible hash solution on end by                               
  Paul Dorfman                                                                         
  sashole@bellsouth.net   
                                                                                                                          
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
                                                                                                                    
     
  See simple, elegant and flexible hash solution on end by                               
  Paul Dorfman                                                                         
  sashole@bellsouth.net                                                                
                                                                                       
                                                                                       
*____             _                                                                    
|  _ \ __ _ _   _| |                                                                   
| |_) / _` | | | | |                                                                   
|  __/ (_| | |_| | |                                                                   
|_|   \__,_|\__,_|_|                                                                   
                                                                                       
;                                                                                      
                                                                                       
                                                                                       
Very nice; and speed-wise, the APPs+SORTN rule.                                        
If sacrificing a bit of speed is acceptable,                                           
the hash object can always be used, like so:                                           
                                                                                       
data have ;                                                                            
   input A1-A5 ;                                                                       
   cards ;                                                                             
1 2 3 4 5                                                                              
5 1 4 2 3                                                                              
3 2 1 4 5                                                                              
5 4 3 2 1                                                                              
;                                                                                      
run ;                                                                                  
                                                                                       
data want (drop = K) ;                                                                 
  if _n_ = 1 then do ;                                                                 
    dcl hash h (multidata:"Y", ordered:"D") ;                                          
    h.definekey ("K") ;                                                                
    h.definedone () ;                                                                  
    dcl hiter ih ("h") ;                                                               
  end ;                                                                                
  set have ;                                                                           
  array A A1-A5 ;                                                                      
  array T T1-T5 ;                                                                      
  do over T ;                                                                          
    K = A ;                                                                            
    h.add () ;                                                                         
  end ;                                                                                
  do _i_ = 1 by 1 while (ih.next() = 0) ;                                              
    T = K ;                                                                            
  end ;                                                                                
  h.clear() ;                                                                          
run ;                                                                                  
                                                                                       
As I said, it's slower than SORTN. However, the hash method offers                     
a much wider functionality since you can also handle dupes, sort                       
single, parallel and multi-dimensional arrays, use any sorting order                   
(even mixed, i.e. ascending by some key arrays and descending by                       
the others), etc. In fact, it's so much fun that I've even endeavored                  
to pen a full-blown paper on the subject (and pr                                       
esent it at SESUG 2018) where all the variations                                       
mentioned above are discussed in gory details:                                         
                                                                                       
https://www.lexjansen.com/sesug/2018/SESUG2018_Paper-288_Final_PDF.pdf                 
                                                                                       
Another alternative is to copy array A to array T en masse using the APP method,       
as you did here, and then use my 20-year long in the tooth                             
quicksort routine (it's been posted on -L, so anyone can cannibalize -                 
I know some folks who still do).                                                       
                                                                                       
                                                                                                               
                                                                                                                    
                                                                                                                    
