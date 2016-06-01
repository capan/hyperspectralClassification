%% Student Name = Hüseyin Çapan Student Number = e213544 
clc ; clear ; close all;
%% Open the Hyperspectral image in MATLAB
x = hdfinfo('C:\Users\capan\Desktop\METU1.2\561DigitalImageProcess\assg1\EO1H1770392009349110KV\EO1H1770392009349110KV.L1R');
sds_info = x.SDS;
hyp_img = hdfread(sds_info); 
%% Hyperspectral Image 
himg = rand(3400,256,242);
himg = int16(himg);
for i=1:242
    pseudo_band = hyp_img(:,i,:);
    pseudo_band_squeeze = squeeze(pseudo_band);
    himg(:,:,i)= pseudo_band_squeeze; 
end
%% creating "6-Band" Image
rgb_img = cat(3,himg(:,:,31),himg(:,:,20),himg(:,:,10));
six_band_img = cat(3,himg(:,:,31),himg(:,:,20),himg(:,:,10),himg(:,:,200),himg(:,:,80),himg(:,:,81));
% analysis = cat(3,himg(:,:,31),himg(:,:,20),himg(:,:,10),himg(:,:,200));
% hyp_rgb_img = cat(3,himg(:,:,10),himg(:,:,29),himg(:,:,42));
figure(1)
rgb_img(rgb_img<0) = 0;
six_band_img(six_band_img<0)=0;
% hyp_img256 =double( rgb_img(1701:1956,1:256,:));
hyp_img256 =double( rgb_img(1801:2056,1:256,:));
imshow(mat2gray(hyp_img256))
lbls = {'urban'; 'water'; 'forest'; 'agri'};
crd = [131,140,17,18 % urban
4,1,47,14 % water
117,24, 30, 24  % forest
178,202,59,48]; % agriculture
% 1280, 1400, 2800, 2940 % tuff
% 2081, 2220, 2580, 2760]; % step
%     r1 = rectangle('Position',[1485 1550 2225 2278])
% r(1) = rectangle('Position',[crd(1),crd(2),crd(3),crd(4)],'FaceColor','r');
%% rectangles
for i = 1:4
r(i) = rectangle('Position',[crd(i,1),crd(i,2),crd(i,3),crd(i,4)]);
end
%% 300 points to analyze from different regions
for j = 1:6
urban(:,:,j) = six_band_img(131:147,140:157,j);
water(:,:,j) = six_band_img(4:50,1:14,j);
agri(:,:,j) =  six_band_img(178:236,202:249,j);
forest(:,:,j) = six_band_img(99:127,28:55,j);
end
urban_ch1 = mat2gray(urban(:,:,1));water_ch1 = mat2gray(water(:,:,1));agri_ch1 = mat2gray(agri(:,:,1));forest_ch1 =mat2gray(forest(:,:,1)); 
urban_ch2 = mat2gray(urban(:,:,2));water_ch2 = mat2gray(water(:,:,2));agri_ch2 = mat2gray(agri(:,:,2));forest_ch2 =mat2gray(forest(:,:,2));
urban_ch3 = mat2gray(urban(:,:,3));water_ch3 = mat2gray(water(:,:,3));agri_ch3 = mat2gray(agri(:,:,3));forest_ch3 =mat2gray(forest(:,:,3));
urban_ch4 = mat2gray(urban(:,:,4));water_ch4 = mat2gray(water(:,:,4));agri_ch4 = mat2gray(agri(:,:,4));forest_ch4 =mat2gray(forest(:,:,4));

for i=1:300
%% 1. and 2. Bands
urban_array1(i) = urban_ch1(i);urban_array2(i) = urban_ch2(i);
water_array1(i) = water_ch1(i);water_array2(i) = water_ch2(i);
agri_array1(i) = agri_ch1(i);agri_array2(i) = agri_ch2(i);
forest_array1(i) = forest_ch1(i);forest_array2(i) = forest_ch2(i);
%% 4. and 3. Bands
urban_array3(i) = urban_ch3(i);urban_array4(i) = urban_ch4(i);
water_array3(i) = water_ch3(i);water_array4(i) = water_ch4(i);
agri_array3(i) = agri_ch3(i);agri_array4(i) = agri_ch4(i);
forest_array3(i) = forest_ch3(i);forest_array4(i) = forest_ch4(i);
end
%% Scatter Plot of 1. and 2. Bands
figure(2)
hold all
xlabel('Channel 1')
ylabel('Channel 2')
plot(urban_array1,urban_array2, '.','Color','k' );
plot(water_array1,water_array2, '.','Color','b' );
plot(agri_array1,agri_array2, '.','Color','r' );
plot(forest_array1,forest_array2, '.','Color','g' );
legend('urban','water','agriculture','forest')
%% Scatter Plot of 3. and 4. Bands
figure(3)
hold all
xlabel('Channel 3')
ylabel('Channel 4')
plot(urban_array3,urban_array4, '.','Color','k' );
plot(water_array3,water_array4, '.','Color','b' );
plot(agri_array3,agri_array4, '.','Color','r' );
plot(forest_array3,forest_array4, '.','Color','g' );
legend('urban','water','agriculture','forest')
%% vector of labels 
urban_s = size(urban);water_s = size(water);forest_s = size(forest);agri_s = size(agri);
urban_vec = reshape (urban,[urban_s(1)*urban_s(2),urban_s(3)]);
water_vec = reshape (water,[water_s(1)*water_s(2),water_s(3)]);
forest_vec = reshape (forest,[forest_s(1)*forest_s(2),forest_s(3)]);
agri_vec = reshape (agri,[agri_s(1)*agri_s(2),agri_s(3)]);
% stack all vectors on top of each other
trn_set = [urban_vec;water_vec;forest_vec;agri_vec];
trn_set = double(trn_set);
% labels for stacked vectors
urb_lbl = ones(urban_s(1)*urban_s(2),1);wtr_lbl = ones(water_s(1)*water_s(2),1)*2;
frst_lbl = ones(forest_s(1)*forest_s(2),1)*3;agri_lbl = ones(agri_s(1)*agri_s(2),1)*4;
lbls = [urb_lbl;wtr_lbl;frst_lbl;agri_lbl];
%% classification
[cls, er] = classify(trn_set, trn_set, lbls, 'mahalanobis');
%% confusion matrix
[C,order] = confusionmat(lbls,cls);
Cf  = cfmatrix2(lbls,cls);


