<?php

namespace App\Http\Controllers;

use App\Models\Transaksi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TransaksiController extends Controller
{
    public function insert(Request $request)
    {
        $transaksi = Transaksi::create($request->all());

        return response()->json(['massage' => 'succes', 'data' => $transaksi]);
    }
    public function index()
    {
        $transaksi = Transaksi::whereNull('tgl_ambil')->get();
        return response()->json(['message' => 'success', 'data' => $transaksi]);
    }

    public function indexNotNull()
    {
        $transaksi = Transaksi::whereNotNull('tgl_ambil')->get();
        return response()->json(['message' => 'success', 'data' => $transaksi]);
    }

    public function update(Request $request, $id)
    {
        $transaksi = Transaksi::find($id);
        $transaksi->update($request->all());
        return response()->json(['massage' => 'success', 'data' => $transaksi]);
    }
    public function updateAmbil(Request $request, $id)
    {
        $transaksi = Transaksi::find($id);

        if (!$transaksi) {
            return response()->json(['message' => 'Transaksi not found'], 404);
        }

        $transaksi->tgl_ambil = now(); // Mengatur nilai tgl_ambil menjadi tanggal saat ini
        $transaksi->save();

        return response()->json(['message' => 'Success', 'data' => $transaksi]);
    }


    public function destroy($id)
    {
        $transaksi = Transaksi::find($id);
        $transaksi->delete();
        return response()->json(['massage' => 'succes', 'data' => null]);
    }
    public function banyak(Request $request)
    {
        $transaksi = Transaksi::count();
        return response()->json(['massage' => 'succes', 'data' => $transaksi]);
    }
    public function status(Request $request)
    {
        $transaksi = Transaksi::where('status', 'selesai')->count();
        return response()->json(['massage' => 'success', 'data' => $transaksi]);
    }
    public function total(Request $request)
    {
        $total = Transaksi::sum('total');
        return response()->json(['massage' => 'success', 'data' => $total]);
    }
    public function keuntungan()
    {
        $transaksi = Transaksi::whereNotNull('tgl_masuk')
            ->groupBy('tgl_masuk')
            ->select('tgl_masuk', DB::raw('SUM(total) as keuntungan'))
            ->get();

        return response()->json(['message' => 'success', 'data' => $transaksi]);
    }
}
