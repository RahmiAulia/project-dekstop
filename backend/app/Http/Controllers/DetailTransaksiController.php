<?php

namespace App\Http\Controllers;

use App\Models\DetailTransaksi;
use Illuminate\Http\Request;

class DetailTransaksiController extends Controller
{
    public function insert(Request $request)
    {
        $detail = DetailTransaksi::create($request->all());
        return response()->json(['massage' => 'succes', 'data' => $detail]);
    }
}
