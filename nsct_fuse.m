function y=nsct_fuse(I1,I2,nlevels)
%    NSCT
%    Input:
%    I1 - input image A
%    I2 - input image B
%    nlevels - number of directions in each decomposition level
%    Output:
%    y  - fused image   


[m,n]=size(I1);
%%金字塔表示参数
Nsc=ceil(log2(min(m,n))-7);
%分解尺度的数量
Nor=8;%每级分解的方向数

%nlevels = [2,3,3,4] ;       
% pfilter = 'pyrexc' ;        
 pfilter = 'maxflat' ;     
% dfilter = 'vk' ; 
dfilter = 'pkva' ; 
 
I1=double(I1);
I2=double(I2);
coeffs_1 = nsctdec( I1, nlevels, dfilter, pfilter );
coeffs_2 = nsctdec( I2, nlevels, dfilter, pfilter );

u=mean2(coeffs_2{1});%均值
s=std2(coeffs_2{1});%方差


coeffs=coeffs_1;
for i=2:numel(nlevels)+1

    if nlevels(i-1)==0
        E1=abs(coeffs_1{i});
        E2=abs(coeffs_2{i});
        %             map=E1>E2;
         um=3;
    A1 = ordfilt2(abs(es2(E1,floor(um/2))), um*um, ones(um));
  	A2 = ordfilt2(abs(es2(E2,floor(um/2))), um*um, ones(um));
    

    % second step
  	map= (conv2(double(A1 > A2), ones(um), 'valid')) > floor(um*um/2);
        coeffs{i}(map)=coeffs_1{i}(map);


    else
        for j=1:(2^nlevels(i-1))

%             
        band=abs(coeffs_1{i}{j})-abs(coeffs_2{i}{j});
        band_coeffs1=double(im2bw(band,0));
        band_coeffs2=ones(size(band))-band_coeffs1;
        coeffs{i}{j}=1.5.*coeffs_1{i}{j}.*band_coeffs1+coeffs_2{i}{j}.*band_coeffs2;
% 
        end
    end

  end


coeffs{1}=(1.5*coeffs_1{1}+coeffs_2{1});%% 可改系数

y= nsctrec( coeffs, dfilter, pfilter ) ;