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

------------------------------------------------------------------------------------------------------------

Reduce : 

(λx. (λy.λz. z y) x) f ((λx. x)(λx. x))             //Alpha
(λx. (λy.λz. z y) x) f ((λa. a)(λb. b))             //Beta 
(λy.λz. z y) f ((λa. a)(λb. b))                     //Beta
(λz. z f)((λa. a)(λb. b))                           //Beta
((λa. a)(λb. b)) f                                  //Beta
(λb. b) f                                           //Beta
f                                                   //Done

------------------------------------------------------------------------------------------------------------

