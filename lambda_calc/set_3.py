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

Reduce : 

(λx.λy.λz.xz(yz))((λx.λy.yx)u)((λx.λy.yx)v)w         //Alpha
(λx.λy.λz.xz(yz))((λa.λb.ba)u)((λc.λd.dc)v)w         //Beta
(λz.((λa.λb.ba)u)z(((λc.λd.dc)v)z))w                 //Beta
((λa.λb.ba)u)w(((λc.λd.dc)v)w)                       //Beta
(λb.bu)w(((λc.λd.dc)v)w)                             //Beta
(wu)(((λc.λd.dc)v)w)                                 //Beta
(wu)((λd.dv)w)                                       //Beta
(wu)(wv)                                             //Done 
wuwv   

------------------------------------------------------------------------------------------------------------
0 = λf.λx.x
1 = λf.λx.fx
2 = λf.λx.f(fx)

n = λf.λx.fn

succ = λn.λf.λx.f(nfx)
iszero = λz.z(λy.false)true

1. Prove that : succ 0 = 1
2. Prove that : succ 1 = 2
3. Prove that : iszero 0 = true
4. Prove that : iszero 1 = false


1 : 
succ 0
(λn.λf.λx.f(nfx)) 0                     //Beta
λf.λx.f(0 f x)  
λf.λx.f((λf.λy.y) f x)                  //Beta
λf.λx.f((λy.y) x)                       //Beta
λf.λx.fx                                //Beta
1

2 :
succ 1
(λn.λf.λx.f(nfx)) 1                     //Beta
λf.λx.f(1 f x)  
λf.λx.f((λf.λx.fx) f x)                 //Beta
λf.λx.f((λx.fx) x)                      //Beta
λf.λx.f(fx)
3    

3 :
iszero 0 
(λz.z(λy.false)true)0                    //Beta
(0(λy.false)true)       
(λf.λx.x)(λy.false)true                  //Beta
(λx.x)true                               //Beta
true

4 :
iszero 1
(λz.z(λy.false)true)1                    //Beta
(1(λy.false)true)       
(λf.λx.fx)(λy.false)true                 //Beta
(λx.(λy.false)x)true                     //Beta 
(λy.false)true                           //Beta
false