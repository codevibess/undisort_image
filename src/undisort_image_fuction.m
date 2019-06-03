function out = undisort_image_fuction(image_name, strength_param, zoom_param)
  
    if ~ exist('image_name', 'var')
        % first parameter does not exist, so default it to something
        image_name = '../images/test2.jpg';
    end
    if ~ exist('strength_param', 'var')
        % second parameter does not exist, so default it to something
        strength_param = 1.0;
    end
    if ~ exist('zoom_param', 'var')
        % third parameter does not exist, so default it to something
        zoom_param = 1.0;
    end
    % here we read the data from file
    % imread return for us 3D matrix, where every submatrix is R or G or B
    source_image = imread(image_name);
    % why i create gray image? because it give posibility to obtain height and width of img in simple way
    J = rgb2gray(source_image);
    % after test remove this stuff
    [image_height, image_width] = size(J);
 
    half_height = image_height / 2;
    half_width = image_width / 2;
    % strenght of barrel disortion removal
    strength = strength_param;
    % use zoom to obtain croped or original size image, where 1.0 means no zoom
    zoom = zoom_param;
    % define a radius
    correct_radius = (image_height ^ 2 + image_width ^ 2) ^ (1 / 2) / strength;
 
    % define a 3d matrix and fill its with zeros
    output_image_matrix = uint8(zeros(image_height, image_width, 3));
 
 
    % iterate over the image (cartesian coordinate)
    for row = 1:image_height
        for column = 1:image_width
            % new position (location) of pixel in cartesian coordinate
            newx = row - half_width;
            newy = column - half_height;
            % distance between a pixel and image center (0, 0)
            distance = (newx ^ 2 + newy ^ 2) ^ (1 / 2);
            % correction radius
            correction_radius = distance / correct_radius;
         
            if (correction_radius == 0)
                theta = 1;
            else
                theta = atan(correction_radius) / correction_radius;
            end
            % new position (location) of pixel in cartesian coordinate
            x_position = round(half_width + theta * newx * zoom);
            y_position = round(half_height + theta * newy * zoom);
         
            output_image_matrix(row, column, 1) = source_image(x_position, y_position, 1);
            output_image_matrix(row, column, 2) = source_image(x_position, y_position, 2);
            output_image_matrix(row, column, 3) = source_image(x_position, y_position, 3);
         
        end
     
    end
 
    imshow(output_image_matrix);
 
end




