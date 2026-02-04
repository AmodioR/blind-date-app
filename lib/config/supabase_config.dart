class SupabaseConfig {
  static const supabaseUrl = 'https://dnzannytscaxmlkzpxwt.supabase.co';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6'
      'ImRuemFubnl0c2NheG1sa3pweHd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAy'
      'MjY0MjEsImV4cCI6MjA4NTgwMjQyMX0.F5YAB0kjEe-2NPJQQ5V190eBiailuWfUmy_v73RQLZ8';
  static bool get isConfigured =>
      supabaseUrl.startsWith('http') && supabaseAnonKey.length > 20;
}
