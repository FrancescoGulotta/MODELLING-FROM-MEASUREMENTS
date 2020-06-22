function npop=poolextraxtion(probab)
v=1:1:numel(probab);
C=cumsum(probab);
npop=v(1+sum(C(end)*rand>C));
end