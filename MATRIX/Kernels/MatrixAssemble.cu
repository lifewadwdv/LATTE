/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Copyright 2010.  Los Alamos National Security, LLC. This material was    !
! produced under U.S. Government contract DE-AC52-06NA25396 for Los Alamos !
! National Laboratory (LANL), which is operated by Los Alamos National     !
! Security, LLC for the U.S. Department of Energy. The U.S. Government has !
! rights to use, reproduce, and distribute this software.  NEITHER THE     !
! GOVERNMENT NOR LOS ALAMOS NATIONAL SECURITY, LLC MAKES ANY WARRANTY,     !
! EXPRESS OR IMPLIED, OR ASSUMES ANY LIABILITY FOR THE USE OF THIS         !
! SOFTWARE.  If software is modified to produce derivative works, such     !
! modified software should be clearly marked, so as not to confuse it      !
! with the version available from LANL.                                    !
!                                                                          !
! Additionally, this program is free software; you can redistribute it     !
! and/or modify it under the terms of the GNU General Public License as    !
! published by the Free Software Foundation; version 2.0 of the License.   !
! Accordingly, this program is distributed in the hope that it will be     !
! useful, but WITHOUT ANY WARRANTY; without even the implied warranty of   !
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General !
! Public License for more details.                                         !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

#include "Kernels.h"

__global__ void MatrixAssembleKernel(const int m, int n, REAL *A, REAL *A2, int nblock, int sub)
{

    // Reading from global memory 
    // Converting from stripes to blocks
    int tidx = threadIdx.x + (blockDim.x * blockIdx.x);
    int blocksize = gridDim.x * blockDim.x;
    int ix, iy, k, kp, index_in, index_out;


    // For contiguous outputs
/*    ix = tidx/n;
    iy = tidx % n;
    k = ix/sub;
    kp = iy/sub; */


    // For contiguous inputs
    ix = (tidx/sub) % sub;
    iy = tidx % sub;
    k = tidx/(n*sub);
    kp =(tidx/(sub*sub)) % nblock;
    
    // Stripe and block indices for contiguous outputs

/*    index_in = k*n*sub + kp*n*(sub/nblock) + (ix%sub) * sub + iy%sub;
    index_out = tidx; */


    // Stripe and block indices for contiguous inputs
    index_in = tidx;
    index_out = k*n*sub + kp*sub + ix*n + iy; 

    // Block value = stripe value
    if (index_out < m && index_in < m)
//      A[index_out] = A2[index_in];
	A[index_out] = A2[index_in];
}
