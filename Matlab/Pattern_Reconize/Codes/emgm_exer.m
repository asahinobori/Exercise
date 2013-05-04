function [label, model, llh ] = emgm_exer(X, init)
% 使用EM算法拟合高斯混合模型（对样本集进行分类）
%   X：d x n 样本集数据矩阵
%   init: k 个类别
fprintf('EM for Gaussian mixture: running ... \n');

% 初始化每个样本的类别，记录于矩阵R里
R = initialization(X, init);
[~,label(1,:)] = max(R, [], 2);     %label是每个样本的类别值
R = R(:,unique(label));

tol = 1e-10;    %收敛阈值
maxiter = 500;  %迭代最大次数
llh = -inf(1, maxiter);     %收敛变化矩阵（初始化为全部都是负无穷）
converged = false;  %收敛标志
t = 1;
while ~converged && t < maxiter
    t = t + 1;
    model = maximization(X,R);  %EM算法的M步，最大化混合高斯模型中的参数估计似然值
    [R, llh(t)] = expectation(X, model); %EM算法的E步，计算新的类别期望值
    
    [~, label(:)] = max(R, [], 2);  %统计新的分类情况
    u = unique(label);
    if size(R,2) ~= size(u, 2)  %新的分类类别数与上一次类别数不一致，
        R = R(:, u);    %删除空的分类
    else
        converged = llh(t)-llh(t-1) < tol * abs(llh(t)); %当迭代变动小于一定阈值时停止迭代
    end
end
llh = llh(2:t); %最终的收敛变化矩阵（负无穷不统计）
if converged
    fprintf('Converged in %d steps.\n', t-1);
else
    fprintf('Not converged in %d steps.\n', maxiter);
end

  function R = initialization(X, init)
    [~, n] = size(X);
    k = init;
    idx = randsample(n, k);     %随机抽取k个样本作为初始分类的中心
    m = X(:, idx);
    %选取与k个初始中心的距离最短的作为那个中心作为初始分类（注意减法中是距离的负数所以用max函数）
    [~, label] = max(bsxfun(@minus, m'*X, dot(m, m, 1)'/2), [], 1);
    %计算分类后类别数，label是u中的位置
    [u, ~, label] = unique(label);
    while k ~= length(u)    %如果分类后类别数与初始设定不同，则重做上面的步骤直至相同
        idx = randsample(n, k);     
        m = X(:, idx);
        [~, label] = max(bsxfun(@minus, m'*X, dot(m, m, 1)'/2), [], 1);
        [u, ~, label] = unique(label);
    end
    %先根据label分类建立稀疏矩阵，然后还原成完整表示的R
    R = full(sparse(1:n,label,1,n,k,n));


  function [R, llh] = expectation(X, model)
  %EM算法的E步，计算混合高斯模型中分类的后验概率
    mu = model.mu;
    Sigma = model.Sigma;
    w = model.weight;   %类别的概率，wiki中的(1)

    n = size(X,2);
    k = size(mu,2);
    logRho = zeros(n,k);

    for i = 1:k
        %计算高斯分布概率密度函数的对数形式，wiki中的(2)的对数形式
        logRho(:,i) = loggausspdf(X,mu(:,i),Sigma(:,:,i));
    end
    logRho = bsxfun(@plus,logRho,log(w));   %对数形式相加即底数相乘，wiki中的(3)的对数形式
    T = logsumexp(logRho,2); %计算似然函数的指数形式的值,wiki中的(4)的对数形式
    llh = sum(T)/n; %wiki中的(4)对所有样本求平均来作为迭代是否继续下去的判断值
    logR = bsxfun(@minus,logRho,T); %对数形式相减即底数相除,wiki中的(5)的对数形式
    R = exp(logR);  %将对数还原，得到类别的后验概率，可以用于新的分类,wiki中的(6)
   



  function model = maximization(X, R)
    [d,n] = size(X);
    k = size(R,2);

    nk = sum(R,1);
    w = nk/n;   %计算新的类别的概率,wiki中的(7)
    mu = bsxfun(@times, X*R, 1./nk);    %计算新的均值,wiki中的(8)

    Sigma = zeros(d,d,k);
    sqrtR = sqrt(R);
    for i = 1:k     %计算新的协方差矩阵,wiki中的(9)
        Xo = bsxfun(@minus,X,mu(:,i));
        Xo = bsxfun(@times,Xo,sqrtR(:,i)');
        Sigma(:,:,i) = Xo*Xo'/nk(i);
        Sigma(:,:,i) = Sigma(:,:,i)+eye(d)*(1e-6); 
    end

    model.mu = mu;
    model.Sigma = Sigma;
    model.weight = w;


  function y = loggausspdf(X, mu, Sigma)
  %通过样本值，均值，协方差计算高斯分布函数密度的对数形式值，即wiki中的(2)的对数形式
    d = size(X,1);
    X = bsxfun(@minus,X,mu);
    [U,p]= chol(Sigma);
    if p ~= 0
        error('ERROR: Sigma is not PD.');
    end
    Q = U'\X;
    q = dot(Q,Q,1); 
    c = d*log(2*pi)+2*sum(log(diag(U)));
    y = -(c+q)/2;


function s = logsumexp(x, dim)
    
    y = max(x,[],dim);
    x = bsxfun(@minus,x,y);
    %为了防止计算过程中数值溢出而采用的迂回计算
    %实际最后s就是wiki中的(4),可以自行验证
    s = y + log(sum(exp(x),dim));
    %wiki中的(4)如果有一项是无限大，那么s中该项就直接是无限大，因为无限减无限是不确定数，上式会返回错误值
    i = find(~isfinite(y));
    if ~isempty(i)
        s(i) = y(i);
    end



