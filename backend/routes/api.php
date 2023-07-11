<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Detail_transaksiController;
use App\Http\Controllers\DetailTransaksiController;
use App\Http\Controllers\KonsumenController;
use App\Http\Controllers\PaketController;
use App\Http\Controllers\TransaksiController;
use App\Models\Konsumen;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/konsumens', [KonsumenController::class, 'insert']);
Route::get('/konsumens-data', [KonsumenController::class, 'index']);
Route::delete('/konsumens-delete/{id}', [KonsumenController::class, 'destroy']);
Route::put('/konsumens-update/{id}', [KonsumenController::class, 'update']);
Route::get('/konsumens-banyak', [KonsumenController::class, 'banyak']);
Route::get('/konsumens-search/{name}', [KonsumenController::class, 'search']);

Route::post('/pakets', [PaketController::class, 'insert']);
Route::get('/pakets-data', [PaketController::class, 'index']);
Route::delete('/pakets-delete/{id}', [PaketController::class, 'destroy']);
Route::put('/pakets-update/{id}', [PaketController::class, 'update']);

Route::post('/petugas', [AdminController::class, 'insert']);
Route::get('/petugas-data', [AdminController::class, 'index']);
Route::delete('/petugas-delete/{id}', [AdminController::class, 'destroy']);
Route::put('/petugas-update/{id}', [AdminController::class, 'update']);
Route::get('/petugas-nama/{username}', [AdminController::class, 'search']);

Route::post('/login', [AuthController::class, 'authenticate']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

Route::post('/transaksi', [TransaksiController::class, 'insert']);
Route::get('/transaksi-data', [TransaksiController::class, 'index']);
Route::get('/transaksi-data/notNull', [TransaksiController::class, 'indexNotNull']);
Route::get('/transaksi-data/untung', [TransaksiController::class, 'keuntungan']);
Route::put('/transaksi-data/update/{id}', [TransaksiController::class, 'update']);
Route::get('/transaksi-data/banyak', [TransaksiController::class, 'banyak']);
Route::get('/transaksi-data/status', [TransaksiController::class, 'status']);
Route::put('/transaksi-data/ambil/{id}', [TransaksiController::class, 'updateAmbil']);
Route::get('/transaksi-data/total', [TransaksiController::class, 'total']);
Route::delete('/transaksi-delete/{id}', [TransaksiController::class, 'destroy']);

Route::post('/details', [DetailTransaksiController::class, 'insert']);
