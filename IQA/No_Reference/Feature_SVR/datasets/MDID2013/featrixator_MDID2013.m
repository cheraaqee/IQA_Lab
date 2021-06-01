function featrix_MDID2013 = featrixator_MDID2013(feactorator, state)
%featrixator_MDID2013 accepts the name of a feactorator's .m-file and generates
%the featrix for MDID2013 for that method.
%	Detailed explanation of the featrixator_MDID2013

switch nargin
	case 1
		colorful = 0;
	case 2
		colorful = state;
end

