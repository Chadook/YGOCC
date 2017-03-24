--A Full Moon Rises
function c4242567.initial_effect(c)
		--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,4242567)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c4242567.spcon)
	e1:SetOperation(c4242567.spop)
	c:RegisterEffect(e1)
	--remove 1 MONSTER WHEN SUMMONED
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242567,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c4242567.target2)
	e2:SetOperation(c4242567.operation2)
	c:RegisterEffect(e2)
		--Remove self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242567,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c4242567.condition3)
	e3:SetTarget(c4242567.target3)
	e3:SetOperation(c4242567.operation3)
	c:RegisterEffect(e3)
end
--banish self

function c4242567.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c4242567.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c4242567.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end


--Sp summon rule
function c4242567.spfilter(c)
	return c:IsSetCard(0x666) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup()
end
function c4242567.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4242567.spfilter,tp,LOCATION_REMOVED,0,3,nil)
end
function c4242567.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c4242567.spfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

--Banish 1 on summon
function c4242567.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		end
	end

function c4242567.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
