function [fvalue,Pvalue]=fpvalues(sse_r,sse_f,ts,p)
for i=1:length(sse_r(:,1))
    for j=1:length(sse_r(1,:))
        fvalue(i,j)=ftest(sse_r(i,j),sse_f(i,j),p,ts);
    end
end
for i=1:length(sse_r(:,1))
    for j=1:length(sse_r(1,:))
        v=ts-2*p-1;
        pf(i,j) = fcdf(fvalue(i,j),p,v);
Pvalue(i,j)=1-pf(i,j);
  end
end
end
