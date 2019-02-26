
function [fmr, fnrm] = ROC( scores_gen,scores_imp,start,end1)

fnrm = end1;
fmr = end1;
for i = start:end1
     fmr(i) =length(find(scores_imp >= i))/length(scores_imp);
     fnrm(i) = length(find(scores_gen <i))/length(scores_gen);
end

end
