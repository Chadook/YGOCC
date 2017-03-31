--Levelution Warrior

function c30039204.initial_effect(c)
	--undestructible by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c30039204.undescon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c30039204.thcon)
	e2:SetOperation(c30039204.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(c30039204.sccon)
	e3:SetTarget(c30039204.sctg)
	e3:SetOperation(c30039204.scop)
	c:RegisterEffect(e3)
	end
	
	function c30039204.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x12F)
end
	
	function c30039204.undescon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c30039204.filter,c:GetControler(),LOCATION_MZONE,0,1,c)
end

function c30039204.thcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12F)
		and not c:IsCode(30039204)
end
function c30039204.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c30039204.thcfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c30039204.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c30039204.sccon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_BATTLE and ep==tp and Duel.GetAttacker()==e:GetHandler()
end

function c30039204.scfilter(c)
	return c:IsSetCard(0x12F) and c:IsAbleToHand()
end

function c30039204.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30039205.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c30039204.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30039204.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end