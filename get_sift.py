import cv2
import numpy

k_num_images = 1840

for i in xrange(1, k_num_images):
    print(i)

    filename = '../images/{}.jpg'.format(i)

    im = cv2.imread(filename)
    gray_im = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)

    sift = cv2.SIFT()
    keypoints = sift.detect(gray_im, None)
    (keypoints, descriptors) = sift.compute(gray_im, keypoints)

    keypoints_filename = 'keypoints_{}.txt'.format(i)
    descriptors_filename = 'descriptors_{}.txt'.format(i)

    with open(keypoints_filename, 'w') as f:
        for k in keypoints:
            f.write('{} {} {} {}'.format(k.pt[0], k.pt[1], k.size, k.angle))
            f.write('\n')

    with open(descriptors_filename, 'w') as f:
        for d in descriptors:
            for data in d:
                f.write('{} '.format(data))
            f.write('\n')