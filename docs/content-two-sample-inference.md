# (PART) Two Sample Inference {-}




# Summary {-}

> Goal: We've got two samples, and want to see if there's the significance difference in means.

## Background {-}

Comparing differences in means is one of the most commonly used procedures in statistics. Take the following use case: Does Product A have better ratings than than Product B? Sure, we could compare averages (i.e. Product A's mean is $4.83$, better than Product B's  $4.79$), but it fails to answer the question: Are the *population* ratings for A better than B? We only have data from a sample of reviews, so we've got to somehow *estimate* the population differences in ratings.

Any student of introductory statistics knows the remedy: the two-sample t-test. But the t-test makes a few strong assumptions about the data, mainly the assumption of normality. This chapter describes alternative tests we can use instead. 

## Choosing a Test {-}

Are your samples independent? Are your population distributions normal, or, are there more than 40 observations in each? If so, choose the **Parametric t-Test**.

Do you care about the magnitude of the difference? Consider the **Permutation Test**. Check the distribution and number of outliers. If the data is skewed, use the *median* variant, and if there are outliers on both tails, consider using trimmed means. 

If you're instead just looking to determine if one sample is greater than the other, use the Wilcoxon Rank-Sum, particularly with skewed distributions or heavy outliers. If we're interested in generating a confidence interval for the difference, we can use the **Mann-Whitney** test. It works similarly to the Wilcoxon Rank-Sum, and results in the same p-value.


# Parametric t-Test {#two-sample-t-test}

## Usage 

Use the t-test if the following 4 assumptions are met:

### Assumptions {-}

1. Random sample from each population
2. Both samples are independent
3. Both population distributions are normal
4. Both population variances are equal

Note: By the Central Limit Theorem, we can assume that the sample means will start looking normal at large sample sizes ($n \geq 30$).

## How It Works 

- Do we know the population variance $\sigma^2$? If so, we'll use the $z$ distribution: $z\sim N(0,1)$
- Is the population variance $\sigma^2$ unknown? If not, we'll then use the $t$ distribution, $t\sim t(df)$, where $df$ is the minimum of the two sample sizes - 1.

## Code

::: {.tab}
<button class="tablinks" onclick="unrolltab(event, 'R1')">R</button>
<button class="tablinks" onclick="unrolltab(event, 'Python1')">Python</button>

::: {#R1 .tabcontent}


```r
abcd123
```

:::

::: {#Python1 .tabcontent}


```python
abcd123
```

:::
:::


<hr>

::: {.tab}
<button class="tablinks" onclick="unrolltab(event, 'R1')">R</button>
<button class="tablinks" onclick="unrolltab(event, 'Python1')">Python</button>

::: {#R1 .tabcontent}


```r
xyz12314
```

:::

::: {#Python1 .tabcontent}


```python
xyz12341
```

:::
:::

# Permutation Test {#two-sample-permutation}

## Usage 

Use the permutation test if the normality assumption is violated, and you're interested in quantifying the difference in some location parameter: mean, trimmed mean, or median. This works well for smaller sample sizes. 

### Assumptions {-}
1. Random sample from each population
2. Both are sampled independently
3. Both population dists are *continuous* (not categorical / discrete)

*Note*: No longer assumption of normality, nor equal variances

## How It Works 

Let $D_{observed}$ represent the difference in means between our samples.

Under the null hypothesis, we'd expect that our observations have no difference in means. So, if we were to randomly switch around (permute) the observations across the samples, we'd expect our test statistic $D$ to stay quite close to $D_{obs}$.

If sample 1 has $m$ observations, and sample 2 has $n$ observations, there are $\binom {m+n}{m} = \frac {(m+n)!}{m!n!}$ permutations when we pool together our observations and reassign them to a group. We can calculate a test statistic $D$ for each one of these permutations.

Our p-value is then just the *fraction of permutations* that have a test statistic $D$ as or more extreme than what was observed $D_{obs}$.

<details><summary> P-value Formula </summary>
<p>
$p\text{-value}_{two\ sided} = \frac{\text{# of |D's|}~\geq~|D_{obs}|}{\binom {m+n}{m}}$
<br>    $p\text{-value}_{lower} = \frac{\text{# of }D\leq D_{obs}}{\binom {m+n}{m}}$
<br>    $p\text{-value}_{upper} = \frac{\text{# of }D\geq D_{obs}}{\binom {m+n}{m}}$
</p>
</details>


Interpretation: Given a p-value of 0.06, there is a 6% chance of observing a difference as extreme as we did under the hypothesis that these samples come from populations with the same distribution.

## Code 

::: {.tab}
<button class="tablinks" onclick="unrolltab(event, 'R2')">R</button>
<button class="tablinks" onclick="unrolltab(event, 'Python2')">Python</button>

::: {#R2 .tabcontent}


```r
# Content
```

:::

::: {#Python2 .tabcontent}


```python
# Content
```

:::
:::


## Variants 

Instead of difference in means, we could use either (1) sums, (2) trimmed means, or (3) medians:

- **Mean/Sum**: Use when pop. dist. is short-tailed (normal looking)
- **Trimmed Mean**: Use when pop. dist. is symmetric but heavy-tailed (some unusually extreme observations are likely)
- **Median**: Use when population distribution is skewed


# Wilcoxon Rank-Sum

## Usage

Wilcoxon Rank-Sum is great for testing with low sample sizes and outliers, since it uses the rank of the observation as opposed to the value itself.

### Assumptions {-}
1. Both population distribution are continuous (not categorical / discrete)

## How It Works

The goal here is to use *ranks*, as opposed to the actual values, to identify differences in location between the two parameters. Why? Ranks are much more resistant to outliers, since a singly high observation is now just ranked at the max, doesn't matter how far above in absolute value it is.

We'll first calculate $W_{obs}$, our test statistic. To do so, we'll first pool both samples together and rank them, assigning a value of `1` to the smallest observation, and `m+n` to the largest (since there are now $m+n$ observations in the pooled group).

$W_{observed}$ is simply the *sum of ranks* of sample 1 observations. 

Why use this instead of the mean of the ranks between the two? Turns out, the sum of ranks of one sample is a linear function of the mean, so there's a 1:1 correspondence between the two. The sum of ranks is just more consistent and easy to calculate. 

As a quick example:


```
##         Obs 1 Obs 2 Obs 3 Obs 4
## sample1    39    49    55    57
## sample2    31    33    46    NA
```

becomes 


```
##        Sample1 Sample1 Sample1 Sample1 Sample2 Sample2 Sample2
## pooled      39      49      55      57      31      33      46
## ranks        3       5       6       7       1       2       4
```

Under the null hypothesis, we'd expect our observations to have no difference in means. So, if we were to randomly switch around (permute) the observations across the samples, we'd expect our test statistic $W^*$ of the particular permutation to remain close to $W_{obs}$.

If sample 1 has $m$ observations, and sample 2 has $n$ observations, there are $\binom {m+n}{m} = \frac {(m+n)!}{m!n!}$ permutations when we pool together our observations and reassign them to a group. We can calculate a test statistic $W^*$ for each one of these permutations.

Our p-value is then just the *fraction of permutations* that have a test statistic $W$ as or more extreme than what was observed $W_{obs}$:

<details><summary> P-value Formula </summary>
<p>

$p-val_{two\ sided} = \frac{\text{# of W's more extreme than } W_{obs} \text{ across both tails}}{\binom {m+n}{m}}$
<br>    $p-val_{lower} = \frac{\text{# of }W\geq W_{obs}}{\binom {m+n}{m}}$
<br>    $p-val_{upper} = \frac{\text{# of }W\leq W_{obs}}{\binom {m+n}{m}}$

</p>
</details>

Interpretation: Given a p-value of 0.06, there is a 6% chance of observing a difference as extreme as we did under the hypothesis that these samples come from populations with the same distribution.


## Code 




# Mann-Whitney 

## Usage


### Assumptions
1. Both pop. dist are continuous (not categorical / discrete)

## How It Works

In a sample of $m$ observations in sample $X$, and $n$ observations in sample $Y$, we want to focus on *each possible pair* of observations. The test statistic is quite simply $U = \text{# pairs for which } X_i < Y_j$. The minimum $U$ can be is $0$, while the max is every possible pair, or $m*n$.

For example, let's say we have two samples, and want to see if sample 1 has a lower location than sample 2. Here's our raw data:


```
##         Obs 1 Obs 2 Obs 3 Obs 4
## Sample1    31    33    46    40
## Sample2    39    49    55    57
```

We then look at every possible combination of the two samples.


```
##    31 33 40 46
## 39 NA NA NA NA
## 49 NA NA NA NA
## 55 NA NA NA NA
## 57 NA NA NA NA
```

Now we can compare the values, and check if the values of the first sample (the columns) are greater than the values of the second sample (rows):


```
##    31 33 40 46
## 39  0  0  1  1
## 49  0  0  0  0
## 55  0  0  0  0
## 57  0  0  0  0
```

Our test statistic $U$ is the sum of the matrix, $2$.

Under the null hypothesis, we'd expect our test statistic not to be that extreme. That is, if we were to randomly permute our values under different label, we'd need to see that our observed test statistic is far more extreme that the rest of the U statistics before concluding that the null hypothesis doesn't apply.

<details><summary> Formal Hypothesis Test </summary>
<p>

Hypothesis Test:
$$
\begin{aligned}
H_0 &: F_1(x) = F_2(x) \\
H_a &: F_1(x) \geq F_2(x) \\
& \text{with a strict inequality for at least one }x
\end{aligned}
$$

P-Value:
$$
\begin{aligned}
p\text{-value}_{two\ sided} &= \frac{\text{# of U's farther from  } \frac{mn}{2}}{\binom {m+n}{m}} \\
p\text{-value}_{lower} &= \frac{\text{# of }U\geq U_{obs}}{\binom {m+n}{m}} \\
p\text{-value}_{upper} &= \frac{\text{# of }U\leq U_{obs}}{\binom {m+n}{m}}
\end{aligned}
$$


</p>
</details>

## Code 



## Note

The Wilcoxon $W$ is linearly related to Mann Whitney $U$, and **results in the same p-value**.

<details><summary> Proof </summary>
<p>
$$
\begin{array}{l}
W_{2} \\
=\sum_{j=1}^{n} R\left(Y_{j}\right) \\
=R\left(Y_{1}\right)+R\left(Y_{2}\right)+\cdots+R\left(Y_{n}\right) \\
=\left[1+\left(\text {number of } X^{\prime} s \leq Y_{1}\right)\right]+\left[2+\left(\text {number of } X^{\prime} s \leq Y_{2}\right)\right]+\cdots \\
=[1+\cdots+n]+\left[\left(\text {number of } X^{\prime} s \leq Y_{1}\right)+\cdots+\left(\text {number of } X^{\prime} s \leq Y_{n}\right)\right] \\
=[1+\cdots+n]+U \\
=\frac{n(n+1)}{2}+U
\end{array}
$$

</p>
</details>
