---
layout: page
title: Our Paper nominated as AMIA 2017 Distinguished Paper Award
date: 2017-11-11 16:31
mathjax : true
categories: pubs
---

The notes will introduce the types of recurrence, and the
corresponding solution for all these recurrence, including some general
telescoping methods and Master Theorem etc.

<!--more-->

# Telescoping a (linear first-order) recurrence

Linear first-order recurrence telescope to a sum.
## When the coeffients are 1

Just telescope it.
$a_n = a_n+n$ with $a_0=1$

### Elementary discrete sums
    * geometric series
    * arthimetic series
    * bionmial (upper)
    * bionmial theorem
    * Harmonic numbers
    * vandermonde convolution 

## When the coffeients are not 1

Multiply/divid by a summation factor.
$a_n = 2a_{n-1} + 2^n$ with $a_0=0$
Divide by $2^n$

$$\frac {a_n}{2^n} = \frac {a_{n-1}}{2^{n-1}} +1$$

### why 2^n? summation factor

For $a_n =x_na_{n-1}+....$

=> Divid by $x_n \cdot x_{n-1} \cdot x_{n-2}.....x_1$
    
$$a =(1+1/n)a_{n-1}+2$$

Then summation factor:
$$\frac {n+1}{n} \cdot \frac {n}{n-1}....\frac {2}{1} = n+1$$

therefore,
$$\frac {a_n}{n+1} = \frac {a_{n-1}}{n}+ \frac {2}{n+1}$$

# Types of recurrences

## First Order

### linear:   $a_n = na_{n-1} - 1$
summation factor + telescoping
=> Divid by $x_n \cdot x_{n-1} \cdot x_{n-2}.....x_1$

### nolinear: $a_n = \frac {1}{a_{n-1}}$
no-closed form solution

#### Simple Convergence 

$$a_n = \frac {1}{1+a_{n-1}}, \quard n>0 a_0 = 1$$

#### Quadratic convergence and Newton’s method

#### Slow convergence


## Second Order

### Linear recurrences with constant coefficients) 

$$a_n = a_{n-1}+2a_{n-2}$$

#### 1. GF
1.1 OGF for linear recurrences.

$$a_n = x_{1}a_{n-1}+x_{2}a_{n-2}+...x_{t}a_{n-t}$$
$$f(z) = g(z) \sum_{0\leq n < t} a_n z^n (mod z^t)$$
where $g(z) = 1- x_{1}z - x_{2}z^2....x_{t}z^t$
$$f(z) = u_{0}(z)-u_{1}(z)...u_{t}(z)$$, dependens on initial values

$a_0,a_1,...a_{t-1}$
$$a(z) = \frac {f(z)}{g(z)}$$

for simple OGF, we can lookup the OGF table to get the a(n).
However, sometimes, the a(z) is complexed expressed by z.

then we can expand generating functions or find functional equations on generating fucntions, to transform the
generating function into the coeffient form of l(z)z^N
Example Solving linear recurrence $$a_n = 5a_{n-1}-8a_{n-2}+4a_{n-3},\quad for \  n \geq 3\  with \  a_0=0,a_1=1,a_2=4$$

Step 1: make recurence valid for all n

when $a_0=0$, it need no delta.
when $a_1=1$, it need $\delta_{n1} = 1$, only works when n = 1
when $a_2=4$, it need $\delta_{n2} = -1$, only works when n = 2
So $$a_n = 5a_{n-1}-8a_{n-2}+4a_{n-3}+\delta_{n1}+\delta_{n_2}$$

Step 2: multiple by $z^n$, and sum on n

since there will only a z for n = 1, and $-z^2$ for n = 2.  
$$A(z) = 5zA(z)-8z^2A(z)+4z^3A(z)+z-z^2$$

Step 3: Solve A(z)

$$A(z) = \frac {z-z^2}{1-5z+8z^2-4z^3}$$

easy found that in the above formation of $\frac {f(z)}{g(z)}$

Step 4: Simplify or partial fractions.

$$A(z) = \frac {z(1-z)}{(1-z)(1-2z)^2}$$, sometimes, there will be partial
fractions.

Step 5: Expand A(Z) to get a_n

$$a_n = n2^{n-1}$$


some other application of generating functions: Probability Generating
Functions to simplify the caculation for expectation and so on, Bivariate Generating Functions based couting and analysis of cost paramters.

#### 2. Operate Method(Multiple roots $x^n$)

We have given a method for finding an exact solution for any linear recurrence.
The process makes explicit the way in which the full solution is determined by
the initial conditions. When the coefficients turn out to be zero and/or some
roots have the same modulus, the result can be somewhat counterintuitive, though
easily understood in this context

#### 3. Analytic combinatorics
Symbolic methods, see more on Analytic combinatorics.

	Step 1: Combinatatorial constructions
	Step 2: Symblic transfer , Get GF equations.
	Step 3: analytic transfer , Get coefficient asymptotic


### variable coefficients: $a_n = na_{n-1}+ (n-1)a_{n-2} + 1$

1. summation factor 
$$a_n = na_{n – 1} + n(n – 1)a_{n – 2} $$
=> Divided by n!

2. Symbolic solution

3. GF and approximation methods



### nolinear: $a_n = a_{n-1} a_{n-2} + \sqrt [2]{a_{n-2}}$


## Higher Order

$a_n = f(a_{n-1},a_{n-2},a_{n-t})$


## Full History

$a_n = n+a_{n-1}+a_{n-2}+...a_{1}$

## Divide-and-Conquer

$a_n = n+a_{\lfloor{n/2}\rfloor}+a_{\lceil{n/2}\rceil}+n$

### Classic examples:
    * Binary search
    * Mergesort
    * Bather network
    * Karatsuba multiplication
    * Strassen matrix multiplication

### Pattern:
* Dividing into a parts of size about $N/\beta$
* Solving recuresively
* Combining solutions with extra cost $\Theta(N^{\gamma}(\log_N)^\delta)$

$$a_n = a_{n/\beta+O(1)}+ a_{n/\beta+O(1)}+....a_{n/\beta+O(1)}+ \Theta(n^{\gamma}(\log_N)^\delta $$
with alpha terms for the sum, telescoping, 
$$ {\alpha}^{\log_{\beta}^n} + \Theta (n^{\gamma}(\log_N)^\delta) $$
is given by 
$$ a_n = \Theta (n^{\gamma}(\log_N)^\delta) \quad when \quad \gamma < log_{\beta}^{\alpha} $$
$$ a_n = \Theta (n^{\gamma}(\log_N)^{\delta+1}) \quad when \quad \gamma = log_{\beta}^{\alpha} $$
$$ a_n = \Theta (n^{\log_{\beta}^{\alpha}} \quad when \quad \gamma > log_{\beta}^{\alpha} $$

More about Master Theorem,
"A Master Theorem for Discrete Divide and Conquer Recurrences", SODA 2011

## Methods for solving recurrence

### 1. Change of Variable
### 2. Repertorie 

Another path to exact solutions in some cases is the so-called repertoire
method, where we use known functions to find a family of solutions similar to
the one sought, which can be combined to give the answer. This method primarily
applies to linear recurrences, involving the following steps:

* Relax the recurrence by adding an extra functional term.
* Substitute known functions into the recurrence to derive identities similar to
the recurrence.
* Take linear combinations of such identities to derive an equation identical to
the recurrence.

    The success of this method depends on being able to find a set of independent
solutions, and on properly handling initial conditions. Intuition or knowledge
about the form of the solution can be useful in determining the repertoire. The
classic example of the use of this method is in the analysis of an equivalence
algorithm by Knuth and Schönhage 

### 3. Bootstrapping

Often we are able to guess the approximate value of the solution to a
recurrence. Then, the recurrence itself can be used to place constraints on the
estimate that can be used to give a more accurate estimate. Informally, this
method involves the following steps:

* Use the recurrence to calculate numerical values.
* Guess the approximate form of the solution.
* Substitute the approximate solution back into the recurrence.
* Prove tighter bounds on the solution, based on the guessed solution and the substitution.
For illustrative purposes, suppose that we apply this method to the Fibonacci
recurrence:
$$ a_n = a_{n – 1} + a_{n – 2} $$ 
for n > 1 with a0 = 0 and a1 = 1.

First, we note that an is increasing. Therefore, $ a_{n – 1} > a_{n – 2} and a_n > 2a_{n–2}$
Iterating this inequality implies that an > 2^{n/2}, so we know that an has at 
least an exponential rate of growth. On the other hand, $a_{n – 2} < a_{n –1}$ 
implies that $ a_n < 2a_{n – 1}, or (iterating) a_n < 2^n $. Thus we have proved upper
and lower exponentially growing bounds on an and we can feel justified in "guessing" a solution of the form $a_n \sim c0{\alpha}^n$, where $\sqrt[2]{2} <\alpha < 2$  From the recurrence,
we can conclude that a must satisfy $a^2 – a – 1 = 0$
Having determined the value a, we can bootstrap and go back to the
recurrence and the initial values to find the appropriate coefficients.

### 4. Perturbation

Another path to an approximate solution to a recurrence is to solve a simpler
related recurrence. This is a general approach to solving recurrences that
consists of first studying simplified recurrences obtained by extracting what
seems to be dominant parts, then solving the simplified recurrence, and finally
comparing solutions of the original recurrence to those of the simplified
recurrence. This technique is akin to a class of methods familiar in numerical
analysis, perturbation methods. Informally, this method involves the following
steps:

* Modify the recurrence slightly to find a known recurrence.
* Change variables to pull out the known bounds and transform into a recurrence
on the (smaller) unknown part of the solution.
* Bound the unknown “error” term.



