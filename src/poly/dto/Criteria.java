package poly.dto;

public class Criteria {

        // DB에서 페이지 처리된 데이터를 가져오는데 필요한 정보

        private int page, perPageNum, startRow, endRow;



        // JSP에서 하단 부분의 페이지 표시 부분에 필요한 정보

        private int totalCount, totalPage, displayPageNum, startPage, endPage;



        // 페이지 처리를 할 때 앞,뒤에 페이지가 있는지 아닌지 확인

        private boolean prev, next;



        // 검색을 위한 멤버 변수 추가

        private String searchType; // 검색 항목

        private String keyword; // 검색하는 문자열



        // 맨처음 시작할 때 list.do로 시작하므로 페이지는 1. 한 페이지에 표시할 데이터의 갯수는 10으로 정한다.

        // 기본 생성자(파라메터가 없는 생성자)를 이용해서 정해줘야 한다.

        public Criteria() {

            // 초기값을 넣는다.

            // 나중에 전달되는 값으로 바뀐다. 전달되는 값이 없으면 유지된다.

            page = 1;

            perPageNum = 10;

            startRow = 1;

            endRow = 10;



            displayPageNum = 10;



            prev = false;

            next = false;

        }// end of Const.



        // 데이터가 들어오면 페이지 정보를 계산한다.

        // startRow, endRow를 계산한다.

        public void calc() {

            // 처음 시작 데이터 = (페이지-1)*한 페이지에 보여줄 데이터의 갯수 + 1

            // (페이지-1)*한 페이지에 보여줄 데이터의 갯수 + 1 : 이전 페이지까지의 데이터를 넘긴다.

            startRow = (page - 1) * perPageNum + 1;

            endRow = startRow + perPageNum - 1;



            // 하단 부분에 표시한 페이지 처리에 필요한 데이터 계산

            // totalPage 구한다. -> startPage, endPage -> prev, next를 구한다.

            // prev는 startPage가 1이 아니면 True, 1이면 False

            // next endPage != totalPage 이면 True

            // 1. totalPage

            totalPage = (totalCount - 1) / perPageNum + 1;

            // 2. startPage, endPage

            startPage = (page - 1) / displayPageNum * displayPageNum + 1;

            endPage = startPage + displayPageNum - 1;

            // endPage는 totalPage를 넘을 수 없다.

            // 그런데 계산에 의해 endPage가 totalPage보다 크면 endPage에다 totalPage를 넣는다.

            if (endPage > totalPage) {

                endPage = totalPage;

            } // end of if;

            // 3. prev, next를 구한다.

            if (startPage != 1) {

                prev = true;

            } // end of if;

            if (endPage != totalPage) {

                next = true;

            } // end of if;



        }// end of calc()



        public int getPage() {

            return page;

        }



        public void setPage(int page) {

            this.page = page;

        }



        public int getPerPageNum() {

            return perPageNum;

        }



        public void setPerPageNum(int perPageNum) {

            this.perPageNum = perPageNum;

        }



        public int getStartRow() {

            return startRow;

        }



        public void setStartRow(int startRow) {

            this.startRow = startRow;

        }



        public int getEndRow() {

            return endRow;

        }



        public void setEndRow(int endRow) {

            this.endRow = endRow;

        }



        public int getTotalCount() {

            return totalCount;

        }



        public void setTotalCount(int totalCount) {

            this.totalCount = totalCount;

        }



        public int getTotalPage() {

            return totalPage;

        }



        public void setTotalPage(int totalPage) {

            this.totalPage = totalPage;

        }



        public int getDisplayPageNum() {

            return displayPageNum;

        }



        public void setDisplayPageNum(int displayPageNum) {

            this.displayPageNum = displayPageNum;

        }



        public int getStartPage() {

            return startPage;

        }



        public void setStartPage(int startPage) {

            this.startPage = startPage;

        }



        public int getEndPage() {

            return endPage;

        }



        public void setEndPage(int endPage) {

            this.endPage = endPage;

        }



        public boolean isPrev() {

            return prev;

        }



        public void setPrev(boolean prev) {

            this.prev = prev;

        }



        public boolean isNext() {

            return next;

        }



        public void setNext(boolean next) {

            this.next = next;

        }



        public String getSearchType() {

            return searchType;

        }



        public void setSearchType(String searchType) {

            this.searchType = searchType;

        }



        public String getKeyword() {

            return keyword;

        }



        public void setKeyword(String keyword) {

            this.keyword = keyword;

        }



        @Override

        public String toString() {

            return "Criteria [page=" + page + ", perPageNum=" + perPageNum + ", startRow=" + startRow + ", endRow=" + endRow

                    + ", totalCount=" + totalCount + ", totalPage=" + totalPage + ", displayPageNum=" + displayPageNum

                    + ", startPage=" + startPage + ", endPage=" + endPage + ", prev=" + prev + ", next=" + next

                    + ", searchType=" + searchType + ", keyword=" + keyword + "]";

        }



    }
