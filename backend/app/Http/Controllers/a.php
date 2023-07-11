<?php

namespace App\Http\Controllers;

use App\Models\Konsumen;
use Illuminate\Http\Request;

class KonsumenController extends Controller
{
    public function insert(Request $request)
    {
        $konsumen = Konsumen::create($request->all());
        return response()->json(['massage' => 'succes', 'data' => $konsumen]);
    }
}
