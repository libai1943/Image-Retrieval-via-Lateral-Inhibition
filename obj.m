function r = obj(chrom)
% Optimization Objective Function based on NCC similarity criterion

global template
global test
x = round(chrom(1,1));
y = round(chrom(1,2));
[a,b] = size(template);


r1 = 0;
r2 = 0;
r3 = 0;
for i = 1:a
    for j = 1:b
       r1 = r1 + template(i,j).^2;
       r2 = r2 + test(x+i,y+j).^2;
       r3 = r3 + template(i,j).*test(x+i,y+j);
    end
end

r = r3./((r2.^0.5)*(r1.^0.5));
       


