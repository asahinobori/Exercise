function [label, model, llh ] = emgm_exer(X, init)
% ʹ��EM�㷨��ϸ�˹���ģ�ͣ������������з��ࣩ
%   X��d x n ���������ݾ���
%   init: k �����
fprintf('EM for Gaussian mixture: running ... \n');

% ��ʼ��ÿ����������𣬼�¼�ھ���R��
R = initialization(X, init);
[~,label(1,:)] = max(R, [], 2);     %label��ÿ�����������ֵ
R = R(:,unique(label));

tol = 1e-10;    %������ֵ
maxiter = 500;  %����������
llh = -inf(1, maxiter);     %�����仯���󣨳�ʼ��Ϊȫ�����Ǹ����
converged = false;  %������־
t = 1;
while ~converged && t < maxiter
    t = t + 1;
    model = maximization(X,R);  %EM�㷨��M������󻯻�ϸ�˹ģ���еĲ���������Ȼֵ
    [R, llh(t)] = expectation(X, model); %EM�㷨��E���������µ��������ֵ
    
    [~, label(:)] = max(R, [], 2);  %ͳ���µķ������
    u = unique(label);
    if size(R,2) ~= size(u, 2)  %�µķ������������һ���������һ�£�
        R = R(:, u);    %ɾ���յķ���
    else
        converged = llh(t)-llh(t-1) < tol * abs(llh(t)); %�������䶯С��һ����ֵʱֹͣ����
    end
end
llh = llh(2:t); %���յ������仯���󣨸����ͳ�ƣ�
if converged
    fprintf('Converged in %d steps.\n', t-1);
else
    fprintf('Not converged in %d steps.\n', maxiter);
end

  function R = initialization(X, init)
    [~, n] = size(X);
    k = init;
    idx = randsample(n, k);     %�����ȡk��������Ϊ��ʼ���������
    m = X(:, idx);
    %ѡȡ��k����ʼ���ĵľ�����̵���Ϊ�Ǹ�������Ϊ��ʼ���ࣨע��������Ǿ���ĸ���������max������
    [~, label] = max(bsxfun(@minus, m'*X, dot(m, m, 1)'/2), [], 1);
    %���������������label��u�е�λ��
    [u, ~, label] = unique(label);
    while k ~= length(u)    %����������������ʼ�趨��ͬ������������Ĳ���ֱ����ͬ
        idx = randsample(n, k);     
        m = X(:, idx);
        [~, label] = max(bsxfun(@minus, m'*X, dot(m, m, 1)'/2), [], 1);
        [u, ~, label] = unique(label);
    end
    %�ȸ���label���ཨ��ϡ�����Ȼ��ԭ��������ʾ��R
    R = full(sparse(1:n,label,1,n,k,n));


  function [R, llh] = expectation(X, model)
  %EM�㷨��E���������ϸ�˹ģ���з���ĺ������
    mu = model.mu;
    Sigma = model.Sigma;
    w = model.weight;   %���ĸ��ʣ�wiki�е�(1)

    n = size(X,2);
    k = size(mu,2);
    logRho = zeros(n,k);

    for i = 1:k
        %�����˹�ֲ������ܶȺ����Ķ�����ʽ��wiki�е�(2)�Ķ�����ʽ
        logRho(:,i) = loggausspdf(X,mu(:,i),Sigma(:,:,i));
    end
    logRho = bsxfun(@plus,logRho,log(w));   %������ʽ��Ӽ�������ˣ�wiki�е�(3)�Ķ�����ʽ
    T = logsumexp(logRho,2); %������Ȼ������ָ����ʽ��ֵ,wiki�е�(4)�Ķ�����ʽ
    llh = sum(T)/n; %wiki�е�(4)������������ƽ������Ϊ�����Ƿ������ȥ���ж�ֵ
    logR = bsxfun(@minus,logRho,T); %������ʽ������������,wiki�е�(5)�Ķ�����ʽ
    R = exp(logR);  %��������ԭ���õ����ĺ�����ʣ����������µķ���,wiki�е�(6)
   



  function model = maximization(X, R)
    [d,n] = size(X);
    k = size(R,2);

    nk = sum(R,1);
    w = nk/n;   %�����µ����ĸ���,wiki�е�(7)
    mu = bsxfun(@times, X*R, 1./nk);    %�����µľ�ֵ,wiki�е�(8)

    Sigma = zeros(d,d,k);
    sqrtR = sqrt(R);
    for i = 1:k     %�����µ�Э�������,wiki�е�(9)
        Xo = bsxfun(@minus,X,mu(:,i));
        Xo = bsxfun(@times,Xo,sqrtR(:,i)');
        Sigma(:,:,i) = Xo*Xo'/nk(i);
        Sigma(:,:,i) = Sigma(:,:,i)+eye(d)*(1e-6); 
    end

    model.mu = mu;
    model.Sigma = Sigma;
    model.weight = w;


  function y = loggausspdf(X, mu, Sigma)
  %ͨ������ֵ����ֵ��Э��������˹�ֲ������ܶȵĶ�����ʽֵ����wiki�е�(2)�Ķ�����ʽ
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
    %Ϊ�˷�ֹ�����������ֵ��������õ��ػؼ���
    %ʵ�����s����wiki�е�(4),����������֤
    s = y + log(sum(exp(x),dim));
    %wiki�е�(4)�����һ�������޴���ôs�и����ֱ�������޴���Ϊ���޼������ǲ�ȷ��������ʽ�᷵�ش���ֵ
    i = find(~isfinite(y));
    if ~isempty(i)
        s(i) = y(i);
    end



