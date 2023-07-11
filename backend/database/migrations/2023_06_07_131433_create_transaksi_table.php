<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transaksis', function (Blueprint $table) {
            $table->id();

            $table->string('id_admin', 30);
            $table->string('id_transaksi', 30);
            $table->string('id_konsumen', 30);
            $table->date('tgl_masuk');
            $table->date('tgl_keluar');
            $table->date('tgl_ambil')->nullable();
            $table->char('total', 50);
            $table->enum('status', ['proses', 'selesai'])->default('proses');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaksis');
    }
};
