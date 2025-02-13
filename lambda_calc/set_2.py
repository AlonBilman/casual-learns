#Taken from 
#UMD Department of Computer Science CMSC330 Fall 2013 Practice Problems 8 Solutions

Make all parentheses explicit in the following λ-expressions 
    a. λx.xz λy.xy    
    b. (λx.xz) λy.w λw.wyzx    
    c. λx.xy λx.yx 

a. solution:  (λx.((x z) (λy.(x y))))             
b. solution:  ((λx.(x z)) (λy.(w (λw.(((w y) z) x))))) 
c. solution:  (λx.((x y) (λx.(y x))))  

--------------------------------------------------------------------------------

Find all free (unbound) variables in the following λ-expressions 
    d. λx.x z λy.x y    
    e. (λx. x z) λy. w λw. w y z x  
    f. λx.xy λx.yx

d. solution:   (λx.((x *z*) (λy.(x y))))    
e. solution:   ((λx.(x *z*)) (λy.(*w* (λw.(((w y) *z*) *x*)))))  
f. solution:   (λx.((x *y*) (λx.(*y* x)))) 

--------------------------------------------------------------------------------

(λz.z) (λy.y y) (λx.x a)          //Beta
(λy.y y) (λx.x a)                 //Beta
(λx.x a) (λx.x a)                 //Beta
(λx.x a) a                        //Beta
a a                               //Done           

--------------------------------------------------------------------------------

(λx.λy.x y y) (λa.a) b            //Beta
(λy.(λa.a) y y) b                 //Beta
(λa.a) b b                        //Beta
b b                               //Done

--------------------------------------------------------------------------------

(λx.x x) (λy.y x) z                //Alpha
(λa.a a) (λy.y x) z                //Beta
(λy.y x) (λy.y x) z                //Beta
(λy.y x) x z                       //Beta   
x x z                              //Done

--------------------------------------------------------------------------------

(λx. (λy. (x y)) y) z              //Alpha
(λx. (λa. (x a)) y) z              //Beta
(λa. (z a)) y                      //Beta
z y                                //Done

--------------------------------------------------------------------------------
((λx.x x) (λy.y)) (λy.y)           //Beta
((λy.y)(λy.y)) (λy.y)              //Beta
(λy.y)(λy.y)                       //Beta
(λy.y)                             //Done

--------------------------------------------------------------------------------

(((λx. λy.(x y))(λy.y)) w)         //Alpha
(((λx. λy.(x y))(λa.a)) w)         //Beta
((λy.((λa.a) y)) w)                //Beta
(λa.a) w                           //Beta        
w                                  //Done

--------------------------------------------------------------------------------

Given:  
    not = λx.((x false) true) 
    true = λx.λy.x 
    false = λx.λy.y 
Prove that:  
    not (not true)  = true

proof: 

not (not true)
λx.((x false) true) (not true)                  //Beta
((not true) false) true
(((λx.((x false) true)) true) false) true       //Beta
(((true false) true) false) true   
((((λx.λy.x)false) true) false) true            //Beta
(((λy.false) true) false) true 
((false) false) true                            //Beta
((λx.λy.y) false) true                          //Beta
(λy.y) true                                     //Beta
true                                            //Done
                                  
--------------------------------------------------------------------------------

Given:  
    or = λx. λy. ((x true) y) 
    true = λx.λy.x 
    false = λx.λy.y

Prove that: 
    or false true = true 

Proof : 

or false true
λx. λy. ((x true) y) false true                 //Beta
λy.((false true) y) true                        //Beta
(false true) true                               
((λx.λy.y) true) true                           //Beta
(λy.y) true                                     //Beta
true                                            //Done

--------------------------------------------------------------------------------

Given:  
    if a then b else c = a b c 
    true = λx.λy.x 
    false = λx.λy.y

Prove that : if false then x else y = y

Proof : 

if false then x else y = y
false x y 
((λx.λy.y) x) y                                 //Beta
(λy.y) y                                        //Beta
y                                               //Done

--------------------------------------------------------------------------------

Given:  
    2 = λf.λy.f (f y) 
    3 = λf.λy.f (f (f y))  
    succ = λz.λf.λy.f (z f y)

Prove that : succ 2 = 3 

Proof:

succ 2 
λz.(λf.λy.f (z f y)) 2                          //Beta
λf.λy.f (2 f y)                                 
λf.λy.f ((λf.λy.f (f y)) f y)                   //Beta
λf.λy.f ((λy.f (f y)) y)                        //Beta
λf.λy.f (f (f y))   
3                            

--------------------------------------------------------------------------------

Given:  
    1 = λf.λy.f y 
    3 = λf.λy.f (f (f y))  
    M * N = λx.(M (N x)) 

Prove that : (* 1 3)  = 3 

Proof:

(* 1 3) 
λx.(1 (3 x))
λx.((λf.λy.f y) (3 x))                          //Beta
λx.(λy.((3 x) y))                               
λx.(λy.((λf.(λy.f (f (f y))) x) y))             //Beta
λx.(λy.((λy.x (x (x y))) y))                    //Beta
λx.(λy.(x (x (x y))))                           //Alpha
λf.λy.f (f (f y))
3                                               //Done


--------------------------------------------------------------------------------

Given:  
    1 = λf.λy.f y 
    2 = λf.λy.f (f y) 
    3 = λf.λy.f (f (f y))  
    M + N = λx.λy.(M x)((N x) y) 

Prove that : (+ 2 1) = 3 

Proof : 
1.

(+ 2 1)
λx.λy.(2 x)((1 x) y) 
λx.(λy.((2 x)((1 x) y)))
λx.(λy.(((λf.λy.f (f y)) x)((1 x) y)))          //Beta
λx.(λy.(λy.x (x y))((1 x) y)) 
λx.(λy.(λy.x (x y))(((λf.λy.f y) x) y))         //Beta
λx.(λy.(λy.x (x y))((λy.x y) y))                //Beta
λx.(λy.(λy.x (x y))(x y))                       //Beta
λx.(λy.(x (x (x y))))                           //Alpha
λf.λy.f (f (f y))                               //Done


2.

(+ 2 1)
λx.λy.(2 x)((1 x) y)
λx.λy.((λf.λy.f (f y)) x)((1 x) y)              //Beta
λx.λy.(λy.x (x y))((1 x) y)                     //Beta
λx.λy.(x (x ((1 x) y)))                     
λx.λy.(x (x (((λf.λy.f y) x) y)))               //Beta
λx.λy.(x (x ((λy.x y) y)))                      //Beta
λx.λy.(x (x (x y)))                             //Alpha
λf.λy.f (f (f y))  
3

//The site answer.

(+ 2 1)
= λx.λy.(2 x)((1 x) y)    
= λx.λy.((λf.λy.f (f y)) x)((1 x) y)  
= λx.λy.(λy.x (x y))((1 x) y)   
= λx.λy.(λy.x (x y))(((λf.λy.f y) x) y)  
= λx.λy.(λy.x (x y))((λy.x y) y)  
= λx.λy.(λy.x (x y))(x y)   
= λx.λy.x (x (x y))    
= λf.λy.f (f (f y))    
= 3