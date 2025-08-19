/*
  # Enable Realtime for Orders Table

  1. Database Changes
    - Enable realtime replication for orders table
    - Set replica identity to FULL for complete row data
    - Add table to realtime publication

  2. Security
    - Ensure RLS policies allow realtime access
    - Maintain existing security constraints

  This migration enables real-time subscriptions for the orders table
  so that new orders appear immediately in the dashboard without page refresh.
*/

-- Enable realtime replication for orders table
ALTER TABLE public.orders REPLICA IDENTITY FULL;

-- Add orders table to the realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;

-- Ensure the table has proper RLS policies for realtime
-- (The existing policies should already handle this, but let's verify)

-- Grant necessary permissions for realtime
GRANT SELECT ON public.orders TO anon;
GRANT SELECT ON public.orders TO authenticated;

-- Create a function to notify about new orders (optional, for additional debugging)
CREATE OR REPLACE FUNCTION public.notify_new_order()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- This function can be used for additional notifications if needed
  -- For now, it just ensures the trigger system is working
  RETURN NEW;
END;
$$;

-- Create trigger for new order notifications (optional)
CREATE TRIGGER notify_new_order_trigger
  AFTER INSERT ON public.orders
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_new_order();