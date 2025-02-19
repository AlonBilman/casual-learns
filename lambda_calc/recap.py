(λf. λy. f (f y)) (λx. + x x) 3         //Beta
(λy. (λx. + x x) ((λx. + x x) y))  3    //Beta
(λx. + x x) ((λx. + x x) 3)             //Beta
 + ((λx. + x x) 3) ((λx. + x x) 3)      //Beta
+ (+ 3 3) (+ 3 3)                       //Delta 
+ 6 6                                   //Delta
12


(λx.(λx.(xx λx.x)λx.x)x)((λx.x)x)       //Alpha
(λa.(λc.(cc λd.d)λe.e)a)((λb.b)x)       //Beta
(λc.(cc λd.d)λe.e)((λb.b)x)             //Beta
(λc.(cc λd.d)λe.e)x                     //Beta            
(xx λd.d)λe.e   


a. Given the following definitions:
A = λx.λy.λz.xzy
B = λx.λy.y
Show that ABABA = AA

ABABA 
(λx.λy.λz.xzy)BABA  
(λy.λz.Bzy)ABA
(λz.BzA)BA
(BBA)A
((λx.λy.y)BA)A
(A)A



(λx. (x (x (y z))) x) (λu.u v)    
(((λu.u v) (y z)) v) (λu.u v)    
((y z) v)v (λu.u v)       

------------------------------------------------------------------------------------------------------------
 
 • I = λx.x                    | Ix = x 
 • K = λx.λy. x                | Kxy = x 
 • S = λx.λy.λz. x z (y z)     | Sxyz = xz(yz)
 • SKK is exactly I        

------------------------------------------------------------------------------------------------------------

Using the standard combinators (S, K, and I) define the expression F as follows: 
    F = S(K(SI))K 
If L is any lambda expression, show that the following is true: 
    FLL = LL 

Proof:
                                                           
FLL 
S(K(SI))KLL
(λx.λy.λz. x z (y z))(K(SI))KLL
(λy.λz.(K(SI)) z (y z))KLL
((K(SI)) L (K L))L
(((λx.λy. x)(SI)) L (K L))L
((λy. (SI)) L (K L))L
((SI)(K L))L 
((λx.λy.λz. x z (y z))I)(K L)L 
(λy.λz. I z (y z))(K L)L 
(λz. I z ((K L) z))L
(I L ((K L) L))
(L((K L) L))
(L(((λx.λy. x) L) L))
(L((λy. L) L))
(L(L))
LL


(S(K(SI))K)LL                                                    S(K(SI))KLL               
((λx.λy.λz. x z (y z))(K(SI))K)LL       //Beta                   K(SI)L(KL)L        
((λy.λz. (K(SI)) z (y z))K)LL           //Beta                   SI(KL)L
(λz. (K(SI)) z (K z))LL                 //Beta                   IL(KLL)
((K(SI)) L (K L))L                                               LL
(((λx.λy. x )(SI)) L (K L))L            //Beta          
((λy. SI) L (K L))L                     //Beta          
(SI (K L))L
((λx.λy.λz. x z (y z) )I (K L))L        //Beta
((λy.λz. I z (y z)) (K L))L             //Beta
(λz. I z ((K L) z))L                    //Beta
(I L ((K L) L))                         //Ix = x
(L ((K L) L))               
(L (((λx.λy. x) L) L))                  //Beta
(L ((λy. L) L))                         //Beta
(L (L))  
LL                                      //Done



(λx. (λy.λz. z y) x) f ((λx. x)(λx. x))   
((λy.λz. z y) f) ((λx. x)(λx. x))
(λz. z f) ((λx. x)(λx. x))
((λx. x)(λx. x)) f 
(λx. x) f 
f


(λx. (λy.λz. z y) x) f ((λx. x)(λx. x))             //Alpha
(λx. (λy.λz. z y) x) f ((λa. a)(λb. b))             //Beta 
(λy.λz. z y) f ((λa. a)(λb. b))                     //Beta
(λz. z f)((λa. a)(λb. b))                           //Beta
((λa. a)(λb. b)) f                                  //Beta
(λb. b) f                                           //Beta
f                                                   //Done