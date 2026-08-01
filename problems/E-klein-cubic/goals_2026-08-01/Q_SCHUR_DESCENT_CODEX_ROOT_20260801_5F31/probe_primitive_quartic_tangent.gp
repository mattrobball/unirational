\\ Exact primitive-input audit for the tangent twisted-cubic operation.
\\ The quartic x^4-x+1 has Galois group S4.  The point
\\ [1:a:a^2:a^3] lies on the displayed smooth cubic whenever q(a)=0.

myF(a,b,c,d) = a^3-a^2*b+a^2*c-a^2*d-a*b^2+3*a*b*c+a*b*d-3*a*c^2+a*c*d+a*d^2-2*b^3+3*b^2*c+2*b^2*d-3*b*c^2+3*b*d^2-c^3-3*c^2*d;
mygrad(a,b,c,d) = [3*a^2-2*a*b+2*a*c-2*a*d-b^2+3*b*c+b*d-3*c^2+c*d+d^2,-a^2-2*a*b+3*a*c+a*d-6*b^2+6*b*c+4*b*d-3*c^2+3*d^2,a^2+3*a*b-6*a*c+a*d+3*b^2-6*b*c-3*c^2-6*c*d,-a^2+a*b+a*c+2*a*d+2*b^2+6*b*d-3*c^2];

pmul(a,b) = {
  my(c=vector(#a+#b-1,k,0));
  for(i=1,#a,for(j=1,#b,c[i+j-1]+=a[i]*b[j]));
  c
};
ppow(a,n) = {
  my(c=[1]);
  for(i=1,n,c=pmul(c,a));
  c
};
padd(a,b) = {
  my(n=max(#a,#b),c=vector(max(#a,#b),k,0));
  for(i=1,#a,c[i]+=a[i]);
  for(i=1,#b,c[i]+=b[i]);
  c
};
pscale(a,c) = vector(#a,i,c*a[i]);
prem(a,q) = lift(Mod(a,q));
vrem(a,q) = vector(#a,i,prem(a[i],q));
minor3(M,c) = matdet(matrix(3,3,i,j,M[i,if(j<c,j,j+1)]));

\\ Build the splitting field with generator y.  The quartic variable x has
\\ lower priority and the cross-ratio variable z has higher priority.
q=x^4-x+1;
h=subst(nfsplitting(q),x,y);
nf=nfinit(h);
r=nfroots(nf,q);
if(#r!=4,error("quartic did not split"));
A=matrix(4,4,i,j,r[j]^(i-1));
if(matdet(A)==0,error("quartic conjugates do not span P3"));
z=varhigher("z",y);

\\ G[i,j] is d(F after the vertex change)/d(y_j) at vertex i.
gentry(i,j) = {my(P=vector(4,k,r[i]^(k-1)),g=mygrad(P[1],P[2],P[3],P[4]));sum(k=1,4,A[k,j]*g[k])};
G=matrix(4,4,i,j,gentry(i,j));
for(i=1,4,if(G[i,i]!=0,error("marked point not on cubic")));

\\ Boundary-normalized tangency matrix in the cross-ratio variable z.
M=matrix(4,4);
M[1,1]=0;              M[1,2]=G[1,2];       M[1,3]=G[1,3];       M[1,4]=G[1,4];
M[2,1]=z*G[2,1];       M[2,2]=0;            M[2,3]=-z*G[2,3];    M[2,4]=-G[2,4];
M[3,1]=(1-z)*G[3,1];   M[3,2]=(1-z)*G[3,2]; M[3,3]=0;            M[3,4]=G[3,4];
M[4,1]=z*(z-1)*G[4,1]; M[4,2]=(z-1)*G[4,2]; M[4,3]=z*G[4,3];     M[4,4]=0;
qt=matdet(M);
if(poldegree(qt,z)!=4,error("tangency determinant is not quartic"));

lam=vector(4,c,(-1)^(c-1)*minor3(M,c));
\\ Affine-in-s coefficient vectors for the four twisted-cubic coordinates.
B=vector(4);
B[1]=[0,z*lam[1],-(1+z)*lam[1],lam[1]];
B[2]=[z*lam[2],-(1+z)*lam[2],lam[2]];
B[3]=[0,-z*lam[3],lam[3]];
B[4]=[0,-lam[4],lam[4]];

\\ Transform back to the original coordinates and evaluate the explicit
\\ cubic in the polynomial-vector arithmetic.
BX=vector(4,i,vector(4,k,sum(j=1,4,A[i,j]*if(k<=#B[j],B[j][k],0))));
PB=vector(4,i,vector(4,j,ppow(BX[i],j-1)));
pull=[0];
addterm(c,e0,e1,e2,e3) = {
  pull=padd(pull,pscale(pmul(pmul(PB[1][e0+1],PB[2][e1+1]),pmul(PB[3][e2+1],PB[4][e3+1])),c))
};
addterm(1,3,0,0,0); addterm(-1,2,1,0,0); addterm(1,2,0,1,0); addterm(-1,2,0,0,1);
addterm(-1,1,2,0,0); addterm(3,1,1,1,0); addterm(1,1,1,0,1); addterm(-3,1,0,2,0);
addterm(1,1,0,1,1); addterm(1,1,0,0,2); addterm(-2,0,3,0,0); addterm(3,0,2,1,0);
addterm(2,0,2,0,1); addterm(-3,0,1,2,0); addterm(3,0,1,0,2); addterm(-1,0,0,3,0);
addterm(-3,0,0,2,1);
pull=vrem(pull,qt);
while(#pull<10,pull=concat(pull,0));

base=pmul(pmul([0,-1,1],[0,-1,1]),pmul([-z,1],[-z,1]));
L=pull[8];
for(i=1,#base,pull[i+1]=prem(pull[i+1]-L*base[i],qt));
C=pull[7];
for(i=1,#base,pull[i]=prem(pull[i]-C*base[i],qt));
for(i=1,#pull,if(prem(pull[i],qt)!=0,print(Str("DEBUG nonzero_pull_index=",i," degree=",poldegree(prem(pull[i],qt),z)));error("double-contact factorization failed")));

S=-C; V=L;
RY=vector(4);
RY[1]=prem(lam[1]*S*(S-V)*(S-z*V),qt);
RY[2]=prem(lam[2]*V*(S-V)*(S-z*V),qt);
RY[3]=prem(lam[3]*S*V*(S-z*V),qt);
RY[4]=prem(lam[4]*S*V*(S-V),qt);
RX=vector(4,i,prem(sum(j=1,4,A[i,j]*RY[j]),qt));
if(prem(myF(RX[1],RX[2],RX[3],RX[4]),qt)!=0,error("residual point is not on cubic"));

Coeff=matrix(4,4,i,j,polcoef(RX[j],i-1,z));
span=matdet(Coeff);
if(span==0,error("primitive-input residual quartic is coplanar"));

out="primitive_quartic_tangent_probe.log";
fd=fileopen(out,"w");
filewrite(fd,"q=x^4-x+1");
filewrite(fd,Str("splitting_field_degree=",poldegree(h,y)));
filewrite(fd,Str("tangency_degree=",poldegree(qt,z)));
filewrite(fd,Str("tangency_discriminant_nonzero=",poldisc(qt,z)!=0));
filewrite(fd,Str("residual_span_nonzero=",span!=0));
filewrite(fd,"Q_SCHUR_PRIMITIVE_INPUT_TANGENT_COPLANARITY_REFUTED");
fileclose(fd);
print("Q_SCHUR_PRIMITIVE_INPUT_TANGENT_COPLANARITY_REFUTED");
quit
