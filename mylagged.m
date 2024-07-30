
function [lagged]=mylagged(ts,lag)
lagged=nan(size(ts));
lagged(lag+1:end,1)=ts(1:end-lag,1);
end  
