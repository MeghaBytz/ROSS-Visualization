function F = ProposalPdf(current,new,index,chainSD)
proposalPDFTime = tic;
%use current instead of center to change back to random walk
global proposalLambda;
global proposalSD
global proposalRecord
global proposalCenter
global proposalLB
global proposalUB
q = 1;
q = unifpdf(new(index),proposalLB(index),proposalUB(index));
F = log(q);
end