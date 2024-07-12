# root
- **broyden1** uses Broyden’s first Jacobian approximation, it is known as Broyden’s good method.
- **broyden2** uses Broyden’s second Jacobian approximation, it is known as Broyden’s bad method.
- **anderson** uses (extended) Anderson mixing.
- **Krylov** uses Krylov approximation for inverse Jacobian. It is suitable for large-scale problem.
- **diagbroyden** uses diagonal Broyden Jacobian approximation.
- **linearmixing** uses a scalar Jacobian approximation.
- **excitingmixing** uses a tuned diagonal Jacobian approximation.

# minimize
- 'Nelder-Mead' 
- 'Powell'      
- 'CG'          
- 'BFGS'        
- 'Newton-CG'   
- 'L-BFGS-B'    
- 'TNC'         
- 'COBYLA'      
- 'COBYQA'      
- 'SLSQP'       
- 'trust-constr'
- 'dogleg'      
- 'trust-ncg'   
- 'trust-exact' 
- 'trust-krylov'

## Unconstrained minimization
- Method **CG** uses a nonlinear conjugate gradient algorithm by Polak and Ribiere, a variant of the Fletcher-Reeves method described in [5] pp.120-122. Only the first derivatives are used.
- Method **BFGS** uses the quasi-Newton method of Broyden, Fletcher, Goldfarb, and Shanno (BFGS) [5] pp. 136. It uses the first derivatives only. BFGS has proven good performance even for non-smooth optimizations. This method also returns an approximation of the Hessian inverse, stored as hess_inv in the OptimizeResult object.
- Method **Newton-CG** uses a Newton-CG algorithm [5] pp. 168 (also known as the truncated Newton method). It uses a CG method to the compute the search direction. See also TNC method for a box-constrained minimization with a similar algorithm. Suitable for large-scale problems.
- Method **dogleg** uses the dog-leg trust-region algorithm [5] for unconstrained minimization. This algorithm requires the gradient and Hessian; furthermore the Hessian is required to be positive definite.
- Method **trust-ncg** uses the Newton conjugate gradient trust-region algorithm [5] for unconstrained minimization. This algorithm requires the gradient and either the Hessian or a function that computes the product of the Hessian with a given vector. Suitable for large-scale problems.
- Method **trust-krylov** uses the Newton GLTR trust-region algorithm [14], [15] for unconstrained minimization. This algorithm requires the gradient and either the Hessian or a function that computes the product of the Hessian with a given vector. Suitable for large-scale problems. On indefinite problems it requires usually less iterations than the trust-ncg method and is recommended for medium and large-scale problems.
- Method **trust-exact** is a trust-region method for unconstrained minimization in which quadratic subproblems are solved almost exactly [13]. This algorithm requires the gradient and the Hessian (which is not required to be positive definite). It is, in many situations, the Newton method to converge in fewer iterations and the most recommended for small and medium-size problems.

## Bound-Constrained minimization
- Method **Nelder-Mead** uses the Simplex algorithm [1], [2]. This algorithm is robust in many applications. However, if numerical computation of derivative can be trusted, other algorithms using the first and/or second derivatives information might be preferred for their better performance in general.
- Method **L-BFGS-B** uses the L-BFGS-B algorithm [6], [7] for bound constrained minimization.
- Method **Powell** is a modification of Powell’s method [3], [4] which is a conjugate direction method. It performs sequential one-dimensional minimizations along each vector of the directions set (direc field in options and info), which is updated at each iteration of the main minimization loop. The function need not be differentiable, and no derivatives are taken. If bounds are not provided, then an unbounded line search will be used. If bounds are provided and the initial guess is within the bounds, then every function evaluation throughout the minimization procedure will be within the bounds. If bounds are provided, the initial guess is outside the bounds, and direc is full rank (default has full rank), then some function evaluations during the first iteration may be outside the bounds, but every function evaluation after the first iteration will be within the bounds. If direc is not full rank, then some parameters may not be optimized and the solution is not guaranteed to be within the bounds.
- Method **TNC** uses a truncated Newton algorithm [5], [8] to minimize a function with variables subject to bounds. This algorithm uses gradient information; it is also called Newton Conjugate-Gradient. It differs from the Newton-CG method described above as it wraps a C implementation and allows each variable to be given upper and lower bounds.

## Constrained Minimization
- Method **COBYLA** uses the Constrained Optimization BY Linear Approximation (COBYLA) method [9], [10], [11]. The algorithm is based on linear approximations to the objective function and each constraint. The method wraps a FORTRAN implementation of the algorithm. The constraints functions ‘fun’ may return either a single number or an array or list of numbers.
- Method **COBYQA** uses the Constrained Optimization BY Quadratic Approximations (COBYQA) method [18]. The algorithm is a derivative-free trust-region SQP method based on quadratic approximations to the objective function and each nonlinear constraint. The bounds are treated as unrelaxable constraints, in the sense that the algorithm always respects them throughout the optimization process.
- Method **SLSQP** uses Sequential Least SQuares Programming to minimize a function of several variables with any combination of bounds, equality and inequality constraints. The method wraps the SLSQP Optimization subroutine originally implemented by Dieter Kraft [12]. Note that the wrapper handles infinite values in bounds by converting them into large floating values.
- Method **trust-constr** is a trust-region algorithm for constrained optimization. It switches between two implementations depending on the problem definition. It is the most versatile constrained minimization algorithm implemented in SciPy and the most appropriate for large-scale problems. For equality constrained problems it is an implementation of Byrd-Omojokun Trust-Region SQP method described in [17] and in [5], p. 549. When inequality constraints are imposed as well, it switches to the trust-region interior point method described in [16]. This interior point algorithm, in turn, solves inequality constraints by introducing slack variables and solving a sequence of equality-constrained barrier problems for progressively smaller values of the barrier parameter. The previously described equality constrained SQP method is used to solve the subproblems with increasing levels of accuracy as the iterate gets closer to a solution.

## Finite-Difference Options
- For Method **trust-constr** the gradient and the Hessian may be approximated using three finite-difference schemes: {‘2-point’, ‘3-point’, ‘cs’}. The scheme ‘cs’ is, potentially, the most accurate but it requires the function to correctly handle complex inputs and to be differentiable in the complex plane. The scheme ‘3-point’ is more accurate than ‘2-point’ but requires twice as many operations. If the gradient is estimated via finite-differences the Hessian must be estimated using one of the quasi-Newton strategies. 
  
