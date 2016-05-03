function [F, chainSD] = ProposalFunction(current,parameterIndex)
global proposedParameterRecord
global proposalLB
global proposalUB
parameter = current;
parameter(parameterIndex) = unifrnd(proposalLB(parameterIndex),proposalUB(parameterIndex));
chainSD = 1;
proposedParameterRecord = [proposedParameterRecord parameter];
F = parameter;
end
