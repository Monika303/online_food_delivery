# ================================================================
# Food Delivery - Python Flask Backend
# Azure SQL Database compatible (replaces server.js)
#
# REQUIREMENTS:
#   pip install flask flask-cors pyodbc python-dotenv
#
# SETUP:
#   1. Copy .env.example to .env and fill in your Azure SQL details
#   2. Run:  python server.py
#   3. Open: http://localhost:3000
# ================================================================

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
import pyodbc
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__, static_folder="public")
CORS(app)

# ── DB CONNECTION STRING ──────────────────────────────────────
# Azure SQL uses ODBC Driver 18 for SQL Server
def get_conn():
    conn_str = (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER={os.getenv('DB_HOST')};"        # e.g. yourserver.database.windows.net
        f"DATABASE={os.getenv('DB_NAME', 'FoodDeliveryDB')};"
        f"UID={os.getenv('DB_USER')};"
        f"PWD={os.getenv('DB_PASSWORD')};"
        "Encrypt=yes;"                            # Required by Azure SQL
        "TrustServerCertificate=no;"             # Required by Azure SQL
        "Connection Timeout=30;"
    )
    return pyodbc.connect(conn_str)


def rows_to_dict(cursor):
    """Convert pyodbc rows to a list of dicts using column names."""
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]


# ── SERVE STATIC FILES ────────────────────────────────────────
@app.route("/")
def index():
    return send_from_directory("public", "index.html")


# ── HEALTH CHECK ──────────────────────────────────────────────
@app.get("/api/ping")
def ping():
    try:
        conn = get_conn()
        conn.close()
        return jsonify({"status": "connected"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ── DASHBOARD STATS ───────────────────────────────────────────
@app.get("/api/stats")
def stats():
    try:
        conn   = get_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT
                (SELECT COUNT(*)           FROM dbo.ORDERS)                             AS totalOrders,
                (SELECT COALESCE(SUM(Amount), 0)
                   FROM dbo.PAYMENT
                  WHERE PaymentStatus = 'completed')                                    AS totalRevenue,
                (SELECT COUNT(*)           FROM dbo.[USER])                             AS totalUsers,
                (SELECT COALESCE(ROUND(AVG(CAST(Rating AS FLOAT)), 1), 0)
                   FROM dbo.FEEDBACK)                                                   AS avgRating
        """)
        row  = cursor.fetchone()
        cols = [col[0] for col in cursor.description]
        data = dict(zip(cols, row))
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── RESTAURANTS ───────────────────────────────────────────────
@app.get("/api/restaurants")
def restaurants():
    try:
        conn   = get_conn()
        cursor = conn.cursor()
        # Azure SQL uses STRING_AGG instead of MySQL's GROUP_CONCAT
        cursor.execute("""
            SELECT
                r.RestaurantID,
                r.Name,
                r.Rating,
                r.City,
                r.StreetName,
                r.StreetNumber,
                r.IsActive,
                STRING_AGG(rc.CuisineType, ', ')
                    WITHIN GROUP (ORDER BY rc.CuisineType) AS Cuisines,
                (SELECT COUNT(*)
                   FROM dbo.ORDERS o
                  INNER JOIN dbo.ORDERITEM oi ON o.OrderID     = oi.OrderID
                  INNER JOIN dbo.MENUITEM  m  ON oi.ItemID     = m.ItemID
                  WHERE m.RestaurantID = r.RestaurantID
                    AND o.Status != 'cancelled')              AS OrderCount
            FROM dbo.RESTAURANT r
            LEFT JOIN dbo.RESTAURANT_CUISINETYPE rc ON r.RestaurantID = rc.RestaurantID
            GROUP BY r.RestaurantID, r.Name, r.Rating, r.City,
                     r.StreetName, r.StreetNumber, r.IsActive
            ORDER BY r.Rating DESC
        """)
        data = rows_to_dict(cursor)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── MENU ITEMS ────────────────────────────────────────────────
@app.get("/api/menu")
def menu():
    try:
        restaurant = request.args.get("restaurant")
        conn       = get_conn()
        cursor     = conn.cursor()

        query = """
            SELECT
                m.ItemID,
                m.RestaurantID,
                m.Name,
                m.Price,
                m.Description,
                m.IsAvailable,
                r.Name AS RestaurantName
            FROM dbo.MENUITEM m
            INNER JOIN dbo.RESTAURANT r ON m.RestaurantID = r.RestaurantID
        """
        params = []
        if restaurant and restaurant != "all":
            query += " WHERE m.RestaurantID = ?"
            params.append(int(restaurant))

        query += " ORDER BY r.Name, m.Name"
        cursor.execute(query, params)
        data = rows_to_dict(cursor)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── USERS ─────────────────────────────────────────────────────
@app.get("/api/users")
def users():
    try:
        conn   = get_conn()
        cursor = conn.cursor()
        # Azure SQL: use TOP 1 subquery instead of MySQL's LIMIT 1
        cursor.execute("""
            SELECT
                u.UserID,
                u.FirstName,
                u.LastName,
                u.Email,
                u.UserName,
                u.UserType,
                u.CreatedAt,
                (SELECT TOP 1 Phone
                   FROM dbo.USER_PHONE
                  WHERE UserID = u.UserID) AS Phone
            FROM dbo.[USER] u
            ORDER BY u.CreatedAt DESC
        """)
        data = rows_to_dict(cursor)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── ORDERS ────────────────────────────────────────────────────
@app.get("/api/orders")
def orders():
    try:
        conn   = get_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT
                o.OrderID,
                o.Status,
                o.TotalPrice,
                o.OrderDate,
                u.UserID,
                u.FirstName + ' ' + u.LastName AS CustomerName,
                p.Method,
                p.PaymentStatus
            FROM dbo.ORDERS o
            INNER JOIN dbo.[USER] u ON o.UserID  = u.UserID
            LEFT  JOIN dbo.PAYMENT p ON o.OrderID = p.OrderID
            ORDER BY o.OrderDate DESC
        """)
        data = rows_to_dict(cursor)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── DELIVERIES ────────────────────────────────────────────────
@app.get("/api/deliveries")
def deliveries():
    try:
        conn   = get_conn()
        cursor = conn.cursor()
        # Azure SQL: use DATEDIFF instead of MySQL's TIMESTAMPDIFF
        cursor.execute("""
            SELECT
                d.DeliveryID,
                d.OrderID,
                d.PickupTime,
                d.DeliveryTime,
                d.DeliveryStatus,
                u.FirstName + ' ' + u.LastName AS DriverName,
                CASE
                    WHEN d.PickupTime IS NOT NULL AND d.DeliveryTime IS NOT NULL
                    THEN DATEDIFF(MINUTE, d.PickupTime, d.DeliveryTime)
                    ELSE NULL
                END AS DurationMinutes
            FROM dbo.DELIVERY d
            INNER JOIN dbo.[USER] u ON d.UserID = u.UserID
            ORDER BY d.DeliveryID DESC
        """)
        data = rows_to_dict(cursor)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── PAYMENTS ──────────────────────────────────────────────────
@app.get("/api/payments")
def payments():
    try:
        conn   = get_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT
                p.PaymentID,
                p.OrderID,
                p.Amount,
                p.Method,
                p.PaymentTime,
                p.PaymentStatus
            FROM dbo.PAYMENT p
            ORDER BY p.PaymentTime DESC
        """)
        data = rows_to_dict(cursor)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── FEEDBACK ──────────────────────────────────────────────────
@app.get("/api/feedback")
def feedback():
    try:
        conn   = get_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT
                f.FeedbackID,
                f.Rating,
                f.Comment,
                f.FeedbackDate,
                u.FirstName + ' ' + u.LastName AS CustomerName,
                r.Name                         AS RestaurantName,
                r.RestaurantID
            FROM dbo.FEEDBACK f
            INNER JOIN dbo.[USER]     u ON f.UserID       = u.UserID
            INNER JOIN dbo.RESTAURANT r ON f.RestaurantID = r.RestaurantID
            ORDER BY f.FeedbackDate DESC
        """)
        data = rows_to_dict(cursor)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ── START ─────────────────────────────────────────────────────
if __name__ == "__main__":
    port = int(os.getenv("SERVER_PORT", 5000))
    print(f"\n✅  Server running at http://localhost:{port}\n")
    app.run(host="0.0.0.0", port=port, debug=True)